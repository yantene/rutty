class RubyExecutor
  LANGUAGE = "ruby"
  VERSION = "3.0.0"

  def initialize(timeout_sec: 3, kill_sec: 5)
    @executor = DockerSandbox.new(docker_image: "#{LANGUAGE}:#{VERSION}-slim-buster")
    @timeout_sec = timeout_sec
    @kill_sec = kill_sec
  end

  # Ruby のサンドボックスでコードを実行する。
  # @param [String] code 実行する Ruby コード。
  # @return [Array<String, String, Integer>] 標準出力、標準エラー出力、終了ステータスの配列。
  def execute!(code)
    Dir.mktmpdir do |dir|
      script_path = File.join(dir, "script.rb")
      File.open(script_path, "w", 0o644) do |f|
        f.write(code)
      end

      stdout, stderr, status = @executor.run!(
        %w[/usr/local/bin/ruby /script.rb],
        timeout_sec: @timeout_sec,
        kill_sec: @kill_sec,
        mount_files: { script_path => "/script.rb" },
      )

      [stdout, stderr, status.exitstatus]
    end
  end
end
