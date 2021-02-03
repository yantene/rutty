require "rails_helper"

RSpec.describe ExecutorEnvironment::Csharp do
  let(:csharp_executor) { Executor.new(ExecutorEnvironment::Csharp) }

  describe "#run!" do
    context "正常に動作するコードを与えたとき" do
      it '"Hello, world!" を標準出力するコードを与えると、stdout が "Hello, world!\n"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = csharp_executor.run!(<<~DOTNET)
          System.Console.WriteLine("Hello, world!");
        DOTNET

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end

      it '3回 "Hello, world!" を標準出力するコードを与えると、stdout が3行の "Hello, world!"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = csharp_executor.run!(<<~DOTNET)
          for(var i = 0; i < 3; i++ )
          {
            System.Console.WriteLine("Hello, world!");
          }
        DOTNET

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\nHello, world!\nHello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end
    end

    context "エラーが発生するコードを与えたとき" do
      it "無効なコードを与えると、rc が 1 で返ること" do
        _stdout, _stderr, rc = csharp_executor.run!(<<~DOTNET)
          foo
        DOTNET

        expect(rc).to eq 1
      end

      it "無効なコードを与えると、標準エラー出力に処理系のエラーが表示されること" do
        _stdout, stderr, _rc = csharp_executor.run!(<<~DOTNET)
          foo
        DOTNET

        expect(stderr).to start_with("/home/runner/script.csx(1,1): error CS0103: The name 'foo' does not exist in the current context\n")
      end
    end

    context "停止しないコードを与えたとき" do
      it "長時間スリープするコードを与えると、SIGKILL により停止させられ、rc が 137 で返ること" do
        _stdout, _stderr, rc = csharp_executor.run!(<<~DOTNET)
          System.Threading.Thread.Sleep(100000);
        DOTNET
         expect(rc).to eq 137
      end
    end
  end
end
