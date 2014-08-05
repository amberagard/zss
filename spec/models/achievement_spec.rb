RSpec.describe Achievement do
  let(:training_path){ TrainingPath.create(name: "Blending In") }

  let!(:foo){ Skill.create(name: "Foo", description: "Bar", training_path: training_path) }
  let!(:bar){ Skill.create(name: "Bar", description: "Foo", training_path: training_path) }

  context ".create" do
    context "with valid data" do
      it "should save the record accurately if the achievement is mastered" do
        Achievement.create(mastered: true, skill: foo)
        actual = Environment.database.execute("SELECT mastered, date, skill_id FROM achievements")
        expected = [[ "true", actual[0][1], foo.id ]]
        expect(actual).to eq expected
      end

      it "should save the record accurately if the achievement is not mastered" do
        Achievement.create(mastered: false, skill: bar)
        actual = Environment.database.execute("SELECT mastered, date, skill_id FROM achievements")
        expected = [ ["false", "", bar.id] ]
        expect(actual).to eq expected
      end
    end

    context "with invalid data" do

    end
  end

  context ".update" do
    it "should update the existing record" do
      Achievement.create(mastered: false, skill: foo)
      Achievement.create(mastered: true, skill: foo)
      actual = Environment.database.execute("SELECT mastered, date, skill_id FROM achievements")
      expected = [["true", actual[0][1], foo.id]]
      expect(actual).to eq expected
    end
  end

  context ".find" do
    it "should find the specific record" do
      Achievement.create(mastered: true, skill: foo)
      actual = Achievement.find(foo)
      expected = [["true", actual[0][1], foo.id]]
      expect(actual).to eq expected
    end
  end
end
