require "open3"
require "shellwords"

class DockerSandbox
  def initialize(
    cpuset_cpus: 0,
    memory: "512m",
    memory_swap: "512m",
    ulimit_nproc: "10:10",
    ulimit_fsize: 1_000_000,
    docker_image: "debian:buster-slim",
    sh_cmd_path: "/bin/sh",
    su_cmd_path: "/bin/su",
    timeout_cmd_path: "/usr/bin/timeout",
    exec_user: "nobody"
  )
    @cpuset_cpus = cpuset_cpus
    @memory = memory
    @memory_swap = memory_swap
    @ulimit_nproc = ulimit_nproc
    @ulimit_fsize = ulimit_fsize
    @docker_image = docker_image
    @sh_cmd_path = sh_cmd_path
    @su_cmd_path = su_cmd_path
    @timeout_cmd_path = timeout_cmd_path
    @exec_user = exec_user
  end

  # Docker のサンドボックスでコマンドを実行する。
  # @param [Array<String>] cmd 実行するコマンド。
  # @param [Integer] timeout_sec 実行許容秒数。この時間を超えると TERM シグナルが飛ぶ。
  # @param [Integer] kill_sec この時間を超えると KILL シグナルが飛ぶ。
  # @param [Hash{String=>String}] mount_files マウント元パスをキー、マウント先パスを値に取るハッシュ。
  # @return [Array<(String, String, Process::Status)>] Open3#capture3 の返り値。
  def run!(cmd, timeout_sec: 3, kill_sec: 5, mount_files: {})
    Open3.capture3(
      *build_run_command(cmd, timeout_sec: timeout_sec, kill_sec: kill_sec, mount_files: mount_files),
    )
  end

  private

  def build_run_command(cmd, timeout_sec: 3, kill_sec: 5, mount_files: {})
    [
      "docker", "run",
      "--net", "none",
      "--cpuset-cpus", @cpuset_cpus,
      "--memory", @memory,
      "--memory-swap", @memory_swap,
      "--ulimit", "nproc=#{@ulimit_nproc}",
      "--ulimit", "fsize=#{@ulimit_fsize}",
      *(mount_files.flat_map { |src, tgt|
        %W[--mount type=bind,source=#{src},target=#{tgt},readonly]
      }),
      @docker_image,
      @timeout_cmd_path, "-k", kill_sec, timeout_sec,
      @su_cmd_path, "-s", @sh_cmd_path, @exec_user,
      "-c", Shellwords.shelljoin(cmd),
    ].map(&:to_s)
  end
end
