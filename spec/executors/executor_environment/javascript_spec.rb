require "rails_helper"

RSpec.describe ExecutorEnvironment::Javascript do
  let(:javascript_executor) { Executor.new(ExecutorEnvironment::Javascript) }

  describe "#run!" do
    context "正常に動作するコードを与えたとき" do
      it '"Hello, world!" を標準出力するコードを与えると、stdout が "Hello, world!\n"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = javascript_executor.run!(<<~JAVASCRIPT)
          console.log("Hello, world!")
        JAVASCRIPT

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end

      it '3回 "Hello, world!" を標準出力するコードを与えると、stdout が3行の "Hello, world!"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = javascript_executor.run!(<<~JAVASCRIPT)
          [...Array(3)].map(() => console.log("Hello, world!"))
        JAVASCRIPT

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\nHello, world!\nHello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end
    end

    context "エラーが発生するコードを与えたとき" do
      it "無効なコードを与えると、rc が 1 で返ること" do
        _stdout, _stderr, rc = javascript_executor.run!(<<~JAVASCRIPT)
          foo
        JAVASCRIPT

        expect(rc).to eq 1
      end

      it "無効なコードを与えると、標準エラー出力に処理系のエラーが表示されること" do
        _stdout, stderr, _rc = javascript_executor.run!(<<~JAVASCRIPT)
          foo
        JAVASCRIPT

        expect(stderr).to start_with("/script.js:1\nfoo\n^\n\nReferenceError:")
      end
    end

    context "停止しないコードを与えたとき" do
      it "長時間スリープするコードを与えると、SIGKILL により停止させられ、rc が 137 で返ること" do
        _stdout, _stderr, rc = javascript_executor.run!(<<~JAVASCRIPT)
          setTimeout(() => {}, 100000)
        JAVASCRIPT

        expect(rc).to eq 137
      end
    end
  end
end
