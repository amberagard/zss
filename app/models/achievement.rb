class Achievement

  attr_reader :mastered, :date, :skill, :skill_id

  def initialize(options)
    @mastered = options[:mastered]
    @date = @mastered ? DateTime.now.to_s : nil
    @skill = options[:skill]
  end

  def self.create(options)
    achievement = Achievement.new(options)
    achievement.exists? ? achievement.save : achievement.update
    achievement
  end

  def exists?
    Environment.database.execute("SELECT * FROM achievements WHERE skill_id=#{@skill.id}") == []
  end

  def update
    Environment.database.execute("UPDATE achievements set mastered='#{@mastered}', date='#{@date}' WHERE skill_id=#{@skill.id}")
  end

  def save
    Environment.database.execute("INSERT INTO achievements (mastered, date, skill_id) VALUES ('#{@mastered}', '#{@date}', '#{@skill.id}')")
    @id = Environment.database.last_insert_row_id
  end

  def self.find(skill_path)
    Environment.database.execute("SELECT mastered, date, skill_id FROM achievements WHERE skill_id='#{skill_path.id}'")
  end
end
