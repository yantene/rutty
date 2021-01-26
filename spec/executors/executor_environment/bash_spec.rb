require "rails_helper"

RSpec.describe ExecutorEnvironment::Bash do
  let(:bash_executor) { Executor.new(ExecutorEnvironment::Bash) }

  describe "#run!" do
    context "正常に動作するコードを与えたとき" do
      it '"Hello, world!" を標準出力するコードを与えると、stdout が "Hello, world!\n"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = bash_executor.run!('echo "Hello, world!"')

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end

      it '3回 "Hello, world!" を標準出力するコードを与えると、stdout が3行の "Hello, world!"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = bash_executor.run!(<<~BASH)
          for i in {1..3}; do     
            echo "Hello, world!"
          done
        BASH

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\nHello, world!\nHello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end
    end

    context "エラーが発生するコードを与えたとき" do
      it "存在しないコマンド foo を呼び出すコードを与えると、rc が 127 で返ること" do
        _stdout, _stderr, rc = bash_executor.run!("foo")

        expect(rc).to eq 127
      end

      it "存在しないコマンド foo を呼び出すコードを与えると、標準エラー出力に処理系のエラーが表示されること" do
        _stdout, stderr, _rc = bash_executor.run!("foo")

        expect(stderr).to eq "/script.sh: line 1: foo: command not found\n"
      end
    end

    context "停止しないコードを与えたとき" do
      it "長時間スリープするコードを与えると、SIGKILL により停止させられ、rc が 137 で返ること" do
        _stdout, _stderr, rc = bash_executor.run!("sleep 100")

        expect(rc).to eq 137
      end
    end

    context "ネットワークを利用しようとしたとき" do
      it "`ping -c1 -W3 8.8.8.8` を実行すると、正常終了しないこと" do
        _stdout, _stderr, rc = bash_executor.run!(%w[ping -c1 -W3 8.8.8.8])

        expect(rc).to_not eq 0
      end
    end
  end
end
