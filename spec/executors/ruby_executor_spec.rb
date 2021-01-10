require "tmpdir"

RSpec.describe RubyExecutor do
  before do
    @executor = RubyExecutor.new
  end

  describe "#execute!" do
    context "正常に動作するコードを与えたとき" do
      it '"Hello, world!" を標準出力するコードを与えると、stdout が "Hello, world!\n"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = @executor.execute!('puts "Hello, world!"')

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end

      it '3回 "Hello, world!" を標準出力するコードを与えると、stdout が3行の "Hello, world!"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = @executor.execute!(<<~RUBY)
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
        _stdout, _stderr, rc = @executor.execute!("foo")

        expect(rc).to eq 1
      end
    end
  end
end
