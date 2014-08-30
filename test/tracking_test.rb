require "cuba/test"
require_relative "../app"

db = Moped::Session.new(["127.0.0.1:27017"])
db.use :stats

prepare do
  [:stats_hourview, :stats_dailyview, :stats_totalview].each do |c|
    db[c].drop()
  end
end

scope do
  test "tracking a hit" do
    id = 13
    time = Time.now

    get "/track?id=#{id}"

    daily = Stats::DailyView.get(time, id)
    hour  = Stats::HourView.get(time, id)
    total = Stats::TotalView.get(time, id)

    assert last_response.ok?

    assert_equal 1, daily[time.month.to_s][time.day.to_s]['t']
    assert_equal 1, hour[time.strftime('%y')]['t']
    assert_equal 1, total['all']['t']
  end
end
