require "rails_helper"

RSpec.describe ExecutorEnvironment::Ruby do
  let(:ruby_executor) { Executor.new(ExecutorEnvironment::Ruby) }

  describe "#run!" do
    context "正常に動作するコードを与えたとき" do
      it '"Hello, world!" を標準出力するコードを与えると、stdout が "Hello, world!\n"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = ruby_executor.run!('puts "Hello, world!"')

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end

      it '3回 "Hello, world!" を標準出力するコードを与えると、stdout が3行の "Hello, world!"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = ruby_executor.run!(<<~RUBY)
          3.times do
            puts "Hello, world!"
          end
        RUBY

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\nHello, world!\nHello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end
    end

    context "エラーが発生するコードを与えたとき" do
      it "存在しないメソッド foo を呼び出すコードを与えると、rc が 1 で返ること" do
        _stdout, _stderr, rc = ruby_executor.run!("foo")

        expect(rc).to eq 1
      end

      it "存在しないメソッド foo を呼び出すコードを与えると、標準エラー出力に処理系のエラーが表示されること" do
        _stdout, stderr, _rc = ruby_executor.run!("foo")

        expect(stderr).to eq "/script.rb:1:in `<main>': undefined local variable or method `foo' for main:Object (NameError)\n"
      end
    end

    context "停止しないコードを与えたとき" do
      it "永久にスリープするコードを与えると、SIGKILL により停止させられ、rc が 137 で返ること" do
        _stdout, _stderr, rc = ruby_executor.run!("sleep")

        expect(rc).to eq 137
      end
    end
  end
end
