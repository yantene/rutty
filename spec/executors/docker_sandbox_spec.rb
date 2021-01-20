require "rails_helper"
require "tmpdir"

RSpec.describe DockerSandbox do
  before do
    @alpine = DockerSandbox.new
  end

  describe "#run!" do
    context "正常に動作するコマンドを実行したとき" do
      it '"/bin/echo hello" を実行すると、標準出力が "hello"、標準エラー出力がなしで正常終了すること' do
        stdout, stderr, status = @alpine.run!(%w[/bin/echo hello])

        aggregate_failures do
          expect(stdout).to eq "hello\n"
          expect(stderr).to eq ""
          expect(status.exitstatus).to eq 0
        end
      end

      it '"echo hello" を実行すると、標準出力が "hello"、標準エラー出力がなしで正常終了すること' do
        stdout, stderr, status = @alpine.run!(%w[echo hello])

        aggregate_failures do
          expect(stdout).to eq "hello\n"
          expect(stderr).to eq ""
          expect(status.exitstatus).to eq 0
        end
      end
    end

    context "ファイルを配置したとき" do
      before do
        @tmpdir = Dir.mktmpdir
      end

      after do
        FileUtils.remove_entry_secure(@tmpdir)
      end

      it "シェルスクリプトを実行できること" do
        script_path = File.join(@tmpdir, "script.sh")
        File.open(script_path, "w", 0o644) do |f|
          f.write(<<~SHELL)
            echo "hello"
          SHELL
        end

        stdout, stderr, status = @alpine.run!(
          %w[/bin/sh /script.sh],
          mount_files: { script_path => "/script.sh" },
        )

        aggregate_failures do
          expect(stdout).to eq "hello\n"
          expect(stderr).to eq ""
          expect(status.exitstatus).to eq 0
        end
      end

      it "ファイルを書き換えられないこと" do
        file_path = File.join(@tmpdir, "file.dat")
        File.open(file_path, "w", 0o644) do |f|
          f.write(<<~DATA)
            echo "data!"
          DATA
        end

        _stdout, _stderr, status = @alpine.run!(
          ["sh", "-c", "echo 'overwrite!!!' > /file.dat"],
          mount_files: { file_path => "/file.dat" },
        )

        expect(status.exitstatus).to_not eq 0
      end
    end

    context "存在しないコマンドを実行したとき" do
      it '"foo bar" を実行すると、正常終了しないこと' do
        _stdout, stderr, status = @alpine.run!(%w[foo bar])

        aggregate_failures do
          expect(stderr).to_not eq ""
          expect(status.exitstatus).to_not eq 0
        end
      end
    end

    context "ネットワークを利用しようとしたとき" do
      it '"curl http://example.com" を実行すると、正常終了しないこと' do
        _stdout, stderr, status = @alpine.run!(%w[curl http://example.com])

        aggregate_failures do
          expect(stderr).to_not eq ""
          expect(status.exitstatus).to_not eq 0
        end
      end
    end

    context "タイムアウト時間よりも時間のかかるコマンドを実行しようとしたとき" do
      it '"sleep 10" を timeout_sec: 3 で実行すると、124 を返し正常終了しないこと' do
        _stdout, stderr, status = @alpine.run!(%w[sleep 10], timeout_sec: 3)

        aggregate_failures do
          expect(stderr).to_not eq ""
          expect(status.exitstatus).to eq 124
        end
      end
    end
  end
end
