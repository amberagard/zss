class TrainingPath

  attr_reader :errors
  attr_reader :name

  def initialize(options)
    @name = options[:name]
  end

  def self.count
    Environment.database.execute("SELECT count(id) FROM training_paths")[0][0]
  end
  # SQLITE returns:
  #
  # SELECT count(*) FROM training_paths;
  # [ [ 0 ] ]
  #
  # SELECT * FROM training_paths;
  # [ [1, "Foo"],
  #   [2, "Bar"] ]

  def self.create(options)
    training_path = TrainingPath.new(options)
    training_path.save!
    training_path
  end

  def save!
    if valid?
      statement = "Insert into training_paths(name) VALUES ('#{name}')"
      Environment.database.execute(statement)
    end
  end

  def valid?
    validate
    @errors.nil?
  end

  def self.find_by_name(name)
    statement = "SELECT * FROM training_paths WHERE name = '#{name}'"
    Environment.database.execute(statement)
  end

  private

  def validate
    if @name.empty?
      @errors = "Name cannot be blank"
    elsif @name.length >= 30
      @errors = "name must be less than 30 characters"
    elsif @name.match(/^\d+$/)
      @errors = "Name must include letters"
    else
      @errors = nil
    end
  end
end
