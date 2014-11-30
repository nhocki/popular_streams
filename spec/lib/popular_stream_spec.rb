require "spec_helper"

RSpec.describe PopularStream do
  let(:one_week) { 60 * 60 * 24 * 7 } # 1 week in seconds.
  let(:stream) { PopularStream.new("popular_stream") }

  # Make a new "Redis" for each test to not leak the doubles.
  before { PopularStream.redis = Redis.new }

  describe ".redis" do
    let(:redis) { double }

    it "is possible to set a redis instace" do
      expect { PopularStream.redis = redis }.not_to raise_error
    end
  end

  describe "#get" do
    before do
      stream.vote(field: '1', time: Time.now - one_week)
      stream.vote(field: '2')
    end

    it "ranks older votes lower than newer votes" do
      expect(stream.get).to eql(['2', '1'])
    end

    it "#get takes limit & offset arguments" do
      expect(stream.get(limit: 1)).to eql(['2'])
      expect(stream.get(offset: 1)).to eql(['1'])
    end

    it "paginates" do
      stream.vote(field: '3', time: Time.now + one_week)
      expect(stream.get(limit: 1, offset: 0)).to eql([ '3' ])
      expect(stream.get(limit: 1, offset: 1)).to eql([ '2' ])
      expect(stream.get(limit: 1, offset: 2)).to eql([ '1' ])
    end
  end

  it "ranks most popular for same time as higher" do
    Timecop.freeze do
      stream.vote(field: '1')
      stream.vote(field: '1')
      stream.vote(field: '2')
      expect(stream.get).to eql(['1', '2'])
    end
  end

  it "accepts a weight for the vote of a specific field" do
    Timecop.freeze do
      stream.vote(field: '1')
      stream.vote(field: '1')
      stream.vote(field: '2', weight: 3)
      expect(stream.get).to eql(['2', '1'])
    end
  end

  it "keeps old votes with lower weight on values" do
    Timecop.freeze do
      stream.vote(field: '1', time: Time.now - 2 * one_week)
      stream.vote(field: '2', time: Time.now - 3 * one_week)

      stream.vote(field: '1')
      stream.vote(field: '2')
    end
    expect(stream.get).to eql(['1', '2'])
  end

  it "#count gets the number of elements and #clear! removes them all" do
    stream.vote(field: '1')
    stream.vote(field: '1')
    expect(stream.count).to eql(1)
    stream.clear!
    expect(stream.count).to eql(0)
  end
end
