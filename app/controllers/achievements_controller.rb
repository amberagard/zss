class AchievementsController
  # def initialize(options)
  #   @mastered? = options[:mastered]
  #   @date = @mastered ? Time.now : nil
  # end

  def self.create(options)
    achievement = Achievement.create(options)
  end


end
