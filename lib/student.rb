require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    stud = Student.new
    stud.id, stud.name, stud.grade = row[0], row[1], row[2]
    stud
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT (?)"
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    stud = self.first_X_students_in_grade_10(1).first
    hold = Student.new
    hold.id = stud[0]
    hold.name = stud[1]
    hold.grade = stud[2]
    hold
  end

  def self.all_students_in_grade_X(num)
    sql = "SELECT * FROM students WHERE grade = (?)"
    DB[:conn].execute(sql, num)
  end
end
