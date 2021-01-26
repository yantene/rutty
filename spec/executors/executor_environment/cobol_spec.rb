require "rails_helper"

RSpec.describe ExecutorEnvironment::Cobol do
  let(:cobol_executor) { Executor.new(ExecutorEnvironment::Cobol) }

  describe "#run!" do
    context "正常に動作するコードを与えたとき" do
      it '"Hello, world!" を標準出力するコードを与えると、stdout が "Hello, world!\n"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = cobol_executor.run!(<<~COBOL)
          IDENTIFICATION DIVISION.
          PROGRAM-ID. HELLO.
          PROCEDURE DIVISION.
            DISPLAY "Hello, world!"
            STOP RUN.
        COBOL

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end

      it '3回 "Hello, world!" を標準出力するコードを与えると、stdout が3行の "Hello, world!"、stderr が ""、rc が 0 で返ること' do
        stdout, stderr, rc = cobol_executor.run!(<<~COBOL)
          IDENTIFICATION DIVISION.
          PROGRAM-ID. HELLO.

          DATA DIVISION.
          WORKING-STORAGE SECTION.
          01 I PIC 9(01).

          PROCEDURE DIVISION.
            PERFORM VARYING I FROM 1 BY 1 UNTIL I > 3
              DISPLAY "Hello, world!"
            END-PERFORM
            STOP RUN.
        COBOL

        aggregate_failures do
          expect(stdout).to eq "Hello, world!\nHello, world!\nHello, world!\n"
          expect(stderr).to eq ""
          expect(rc).to eq 0
        end
      end
    end

    context "エラーが発生するコードを与えたとき" do
      it "無効なコードを与えると、rc が 1 で返ること" do
        _stdout, _stderr, rc = cobol_executor.run!(<<~COBOL)
          foo
        COBOL

        expect(rc).to eq 1
      end

      it "無効なコードを与えると、標準エラー出力に処理系のエラーが表示されること" do
        _stdout, stderr, _rc = cobol_executor.run!(<<~COBOL)
          foo
        COBOL

        expect(stderr).to start_with("/script.cob:1: error:")
      end
    end

    context "停止しないコードを与えたとき" do
      it "長時間スリープするコードを与えると、SIGKILL により停止させられ、rc が 137 で返ること" do
        _stdout, _stderr, rc = cobol_executor.run!(<<~COBOL)
          IDENTIFICATION DIVISION.
          PROGRAM-ID. SLEEP.

          DATA DIVISION.
          WORKING-STORAGE SECTION.
          01 I PIC 9(01).

          PROCEDURE DIVISION.
            CALL "C$SLEEP" USING 100
            PERFORM VARYING I FROM 1 BY 1 UNTIL I > 3
              DISPLAY "Hello, world!"
            END-PERFORM
            STOP RUN.
        COBOL

        expect(rc).to eq 137
      end
    end
  end
end
