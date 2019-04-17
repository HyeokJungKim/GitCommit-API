class User < ActiveRecord::Base
  has_many :commits

  def scrape_github
    doc = Nokogiri::HTML(open("http://github.com/#{self.github_username}"))
  end

  def get_last_commit
    scrape_github.css("rect")[-1]
  end

  def check_commit
    information_hash = get_last_commit.attributes
    num = information_hash["data-count"].value.to_i
    date_string = information_hash["data-date"].value
    date = Date.strptime(date_string, "%Y-%m-%d")

    if date.today? && num > 0
      Commit.create(user: self, date_reference: "#{date_string}-#{self.github_username}")
      return "#{self.name}: Nice! You've been committing for #{self.streak} day(s) in a row! ✅"
    else
      self.update(streak: 0)
      return "#{self.name}: Disappointing... Your streak is reset to 0...  😢"
    end
  end

  def self.check_all
    puts "=" * 25
    User.all.each do |user|
      puts user.check_commit
    end
    puts "=" * 25
  end
end
