require "rails_helper"

RSpec.describe Executor do
  let(:executor) { Executor.new(double("executor_environment")) }

  describe "#start_container!" do
    let(:alpine_image) { Docker::Image.create(fromImage: "alpine:3.13.0") }

    it "標準出力が得られること" do
      container = Docker::Container.create(Image: alpine_image.id, Cmd: %w[echo hello])

      stdout, _stderr, _rc = executor.send(:start_container!, container)
      expect(stdout).to eq "hello\n"

      container.delete
    end

    it "標準エラー出力が得られること" do
      container = Docker::Container.create(Image: alpine_image.id, Cmd: ["/bin/sh", "-c", "echo good-by >&2"])

      _stdout, stderr, _rc = executor.send(:start_container!, container)
      expect(stderr).to eq "good-by\n"

      container.delete
    end

    it "リターンコードが得られること" do
      container = Docker::Container.create(Image: alpine_image.id, Cmd: %w[/bin/sh -c false])

      _stdout, _stderr, rc = executor.send(:start_container!, container)
      expect(rc).to eq 1

      container.delete
    end
  end

  describe "#create_container!" do
    let(:hello_image) { Docker::Image.create(fromImage: "hello-world") }

    it "作成されたコンテナが動作すること" do
      executor.send(:create_container!, hello_image.id) do |container|
        expect(container.json.dig("State", "Status")).to eq "created"
        container.start
        expect(container.json.dig("State", "Status")).to eq "exited"
      end
    end

    it "実行後コンテナが削除されること" do
      used_container = nil
      executor.send(:create_container!, hello_image.id) do |container|
        container.start
        used_container = container
      end

      expect {
        used_container.start
      }.to raise_error(Docker::Error::NotFoundError)
    end
  end
end
