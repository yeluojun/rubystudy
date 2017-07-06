# task :hello_word do
#   puts "hello world !"
# end

# 普通的任务
desc "例子二"
task :example_two do
  puts "this is task two"
end

# 带参数的任务
desc "my info"
task :my_personal_info, [:name, :sex, :age] do |t, args|
  puts "my name is #{args.name}, sex is #{args.sex}, age is #{args.age}"
end

# 带依赖的任务
task :base_example do
  puts 'this is base example'
end

task other_example: :base_example do
  puts 'this is other example'
end

task another_example: :other_example do
  puts 'this is another example'
end


desc "another person info"
task :another_person_info, [:weight, :height] do |t, args|
  # 依赖的另一种方式
  task(:my_personal_info).invoke("ye", "male", 23)
  puts "my weight is #{args.weight} and my height is #{args.height}"
end

# 带命名空间的任务
namespace :article do
  desc "新建一篇文章"
  task :create_aticle do
    puts "create a new article"
  end
end
