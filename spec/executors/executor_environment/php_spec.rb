require "rails_helper"

RSpec.describe ExecutorEnvironment::Php do
  let(:php_executor) { Executor.new(ExecutorEnvironment::Php) }

  describe "#run!" do
    context "正常に動作するコードを与えたとき" do
      it '"Hello, world!" を標準出力するコードを与えると、stdout が "Hello, world!\n"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = php_executor.run!("Hello, world!\n")

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end

      it '3回 "Hello, world!" を標準出力するコードを与えると、stdout が3行の "Hello, world!"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = php_executor.run!(<<~PHP)
          <?php
          for ($i = 0; $i < 3; $i++) {
            echo "Hello, world!\n";
          }
        PHP

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\nHello, world!\nHello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end
    end

    context "エラーが発生するコードを与えたとき" do
      it "存在しないメソッド foo を呼び出すコードを与えると、rc が 255 で返ること" do
        _stdout, _stderr, rc = php_executor.run!(<<~PHP)
          <?php
          foo();
        PHP

        expect(rc).to eq 255
      end

      it "存在しないメソッド foo を呼び出すコードを与えると、標準エラー出力に処理系のエラーが表示されること" do
        _stdout, stderr, _rc = php_executor.run!(<<~PHP)
          <?php
          foo();
        PHP

        expect(stderr).to start_with("Fatal error:")
      end
    end

    context "停止しないコードを与えたとき" do
      it "長時間スリープするコードを与えると、SIGKILL により停止させられ、rc が 137 で返ること" do
        _stdout, _stderr, rc = php_executor.run!(<<~PHP)
          <?php
          sleep(100);
        PHP

        expect(rc).to eq 137
      end
    end
  end
end
