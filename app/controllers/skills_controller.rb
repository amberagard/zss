class SkillsController
  def initialize(origin_training_path)
    @origin_training_path = origin_training_path
  end

  def add
    puts "What #{@origin_training_path.name} skill do you want to add?"
    puts "Skill Name"
    name = clean_gets
    puts "Skill Description"
    description = clean_gets
    skill = Skill.create(name: name, description: description, training_path: @origin_training_path)
    if skill.new_record?
      puts skill.errors
    else
      puts "#{name} has been added to the #{@origin_training_path.name} training path"
    end
  end

  def list
    puts "=============="
    puts "#{@origin_training_path.name.upcase} SKILLS"
    puts "=============="
    @origin_training_path.skills.each_with_index do |skill, index|
      puts "#{index + 1}. #{skill.name}"
    end
    Router.navigate_skills_menu(self)
  end

  def view(path_number)
    skill_path = skill_paths[path_number - 1]
    if skill_path
      puts "SKILL NAME: #{skill_path.name}"
      puts "SKILL DESCRIPTION: #{skill_path.description}"
      achievement = Achievement.find(skill_path)
      if achievement != []
        puts "You mastered this skill on #{achievement[0][1]}."
      else
        puts "Have you mastered this skill? (y/n)"
        Router.check_mastery(skill_path)
      end
    else
      puts "Sorry, skill path #{path_number} doesn't exist."
    end
  end

  def skill_paths
    @skill_paths ||= Skill.all("WHERE training_path_id = #{@origin_training_path.id}")
  end
end
