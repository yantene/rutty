class Executor
  def initialize(
    environment,
    memory: 512 * (2**10)**2, # 512MiB
    memory_swap: 512 * (2**10)**2, # 512MiB
    cpuset_cpus: "0", # Use Core 0
    ulimit_nproc_hard: 105, # 105 processes
    ulimit_nproc_soft: 105, # 105 processes
    ulimit_fsize_hard: 1_000_000, # 1MB
    ulimit_fsize_soft: 1_000_000 # 1MB
  )

    @environment = environment

    @host_config = {
      "NetworkMode" => "none",
      "Memory" => memory,
      "MemorySwap" => memory_swap,
      "CpusetCpus" => cpuset_cpus,
      "Ulimits" => [
        {
          "Name" => "fsize",
          "Hard" => ulimit_fsize_hard,
          "Soft" => ulimit_fsize_soft,
        },
        {
          "Name" => "nproc",
          "Hard" => ulimit_nproc_hard,
          "Soft" => ulimit_nproc_soft,
        },
      ],
    }
  end

  # サンドボックスでスクリプトを実行する。
  # @param [String] script 実行したいスクリプトコード
  # @return [Array<(String, String, Integer)>] スクリプトの標準出力、標準エラー出力、リターンコード
  def run!(script)
    result = nil

    create_container!(@environment.image_id) do |container|
      container.store_file(@environment::SCRIPT_PATH, script)

      result = start_container!(container)
    end

    result
  end

  private

  # コンテナを実行し標準出力、標準エラー出力、リターンコードを得る。
  # @param [Docker::Container] container 実行するコンテナ
  # @param [Integer] timeout_sec SIGKILL を送るまで待つ秒数
  # @return [Array<(String, String, Integer)>] コンテナの標準出力、標準エラー出力、リターンコード
  def start_container!(container, timeout_sec = 5)
    container.start

    begin
      container.wait(timeout_sec)
    rescue Docker::Error::TimeoutError
      container.kill
    end

    stdout = container.streaming_logs(stdout: true).force_encoding("UTF-8")
    stderr = container.streaming_logs(stderr: true).force_encoding("UTF-8")
    rc = container.wait["StatusCode"]

    [
      stdout,
      stderr,
      rc,
    ]
  end

  # イメージIDとブロックを取り、コンテナを作成、ブロック実行、削除する。
  # @param [String] docker_image_id イメージ ID
  def create_container!(docker_image_id)
    container = Docker::Container.create(
      Image: docker_image_id,
      HostConfig: @host_config,
      NetworkDisabled: true,
    )

    yield container

    container.delete
  end
end
