env "MAILTO", "her@mint.lgbt"

every 1.day do
  runner "HitCounter.new.prune!"
end

every :sunday, :at => "3:00 am" do
  runner "Reports.generate_all"
end
