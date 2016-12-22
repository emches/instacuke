require 'watir-webdriver'
require 'watir-scroll'

Watir.default_timeout = 500

Given(/^I go to pictacular$/) do
  @b=Watir::Browser.new

  sureLoadLink(90){
    @b.goto("http://www.pictacular.co/")
    @b.window.maximize
  }
end

def sureLoadLink(mytimeout)
 browser_loaded=0
 while (browser_loaded == 0)
 begin
  browser_loaded=1
  Timeout::timeout(mytimeout)  do
   yield
  end
  rescue Timeout::Error => e
   puts "Page load timed out: #{e}"
   browser_loaded=0
   retry
  end
 end
end

And(/^I login as pupsofbk$/) do
  @b.div(:class=> "login").when_present.click
  @b.text_field(:id => 'id_username').when_present.set 'pupsofbk'
  @b.text_field(:id => 'id_password').when_present.set 'buddy224'
    @b.text_field(:id => 'id_password').send_keys :enter

  #sleep 4
  #@b.input(:class=> "button-green").when_present.click
end

And(/^I search for lovemydog hashtags$/) do
  @b.button(:name => 'btn-grid-style', :value => 'small').when_present.click
  @b.a(:class=>'lnk_photo').wait_until_present
  @b.a(:class=> "btn-search-tag").when_present.click
  puts @b.text_field(:id => 'tag-search').class_name
  @b.text_field(:id => 'tag-search').set 'furbaby'
  @b.text_field(:id => 'tag-search').send_keys :enter
  @b.a(:class=>'lnk_photo').wait_until_present
end

And(/^I like all of the posts$/) do
  @b.a(:class=>'lnk_photo').wait_until_present

  @clicks = 0

  hearts = @b.links(:class => 'likes')

    while @clicks < 30 do
     heart =  hearts[@clicks]
     if heart.present? && heart.class_name != 'likes engaged'
       puts heart.class_name
       puts heart.wd.location[1].to_s
       @b.execute_script("window.scrollTo(0,"+(heart.wd.location[1] - 50).to_s+")");
       heart.when_present.click
       @clicks+=1
       puts "#{@clicks}"
     end
   end
end

And(/^I go into instagram$/) do
  @b=Watir::Browser.new
  sureLoadLink(90){
    @b.goto("http://www.instagram.com/")
    @b.window.maximize
  }
end

And(/^I log into the instagram web app$/) do
  @b.a(:class=> "_fcn8k").when_present.click
  @b.text_field(:name => 'username').when_present.set 'pupsofbk'
  @b.text_field(:name => 'password').when_present.set 'buddy224'
  @b.text_field(:name => 'password').send_keys :enter
  sleep 1
  if @b.p(:id => 'slfErrorAlert').exists?
  @b.text_field(:name => 'username').when_present.set 'pupsofbk'
  @b.text_field(:name => 'password').when_present.set 'buddy224'
  @b.text_field(:name => 'password').send_keys :enter
  end
 # @b.button(:text => 'Log in').click
end

And(/^I search for ilovemydog hashtags on the insta web app$/) do

  #@b.text_field(:class=> "_9x5sw").when_present.set 'lovemydog'
  #@b.link(:href, "/explore/tags/lovemydog/").when_present.click
  @b.goto('http://instagram.com/explore/tags/lovemydog/')
  #@b.span(:class=>"_4z8bb", :text => "puppiesofinstagram").when_present.click
  #@b.a(:class=>'_8mlbc').wait_until_present

end

And(/^I like( and follow)? all of the intagram web app posts$/)  do |follow|
  @b.a(:class=>'_8mlbc').wait_until_present

  @clicks = 0
  @index = 0

  hearts = @b.links(:class => '_8mlbc')
  liked=[]

  while @clicks < 50 do
     if @clicks == 25
      sleep 300
     end

     heart =  hearts[@index]
     heart.when_present.click
     @b.a(:class=>'_ebwb5').wait_until_present

     if @b.a(:class => '_1tv0k').present?
        @b.a(:class => '_1tv0k').click
        @clicks+=1
        puts "clicks #{@clicks}"
     end

     if follow && @b.button(:text => 'Follow').present?
        @b.button(:text => 'Follow').click
        user = @b.a(:class=>"_aj7mu").text
        puts "Followed #{user}"
        @b.button(:text => 'Following').wait_until_present
     end


     @index+=1
     puts "img #{heart.img.id}"
     liked.push(heart.img.id)

     @b.button(:class=>"_3eajp").click
     puts "index #{@index}"
     puts "hearts len #{hearts.length}"



     if @index == hearts.length+1 || @b.a(:class => "_ebwb5").present?
       puts "NEED MORE"
       if @b.a(:class => "_oidfu").present?
          @b.a(:class => "_oidfu").click
          @b.a(:class => "_oidfu").wait_while_present
       end

       hearts  = @b.links(:class => '_8mlbc')
       puts "new heart len #{hearts.length}"

    end
      puts "I'm STUCK at #{@clicks}"
  end

  puts "I finished?"
end

And(/^I go to the baby.beckham page$/) do
  # => @b.text_field(:class=> "_9x5sw").when_present.set 'baby.beckham'
  #@b.link(:href, "/baby.beckham/").when_present.click
  @b.goto("http://instagram.com/manny_the_frenchie")
  #@b.span(:class=>"_4z8bb", :text => "puppiesofinstagram").when_present.click
  @b.a(:class=>'_8mlbc').wait_until_present
end

And(/^I follow 30 of baby.beckham's followers$/) do
  pics = []
  @b.links(:class => '_8mlbc').each do |pic|
      pics.push(pic.href)
  end
  follows = 0
  index = 0

    for pic in pics
      if follows >=40 then
        break
      end
      puts "pic: #{pic}"
      #pic.click
      @b.goto(pic)
      @b.a(:class=>'_4zhc5').wait_until_present

        if @b.button(:text=>/view all \d* comments/).exists?
          @b.button(:text=>/view all \d* comments/).when_present.click
          @b.button(:text=>/view all \d* comments/).wait_while_present
        end

      commenters = @b.links(:class=>'_4zhc5').to_a
      puts "cmmenters #{commenters}"
      puts "#{commenters.length}"
      commenters = commenters.slice(1,commenters.length-1)

      textlinks = []
      for commenter in commenters
          puts "commenter: #{commenter.text}"
          textlinks.push(commenter.text)
      end

      for textlink in textlinks
        puts "follows #{follows}"
        if follows >=40 then
          break
        end

        puts "text: #{textlink}"
        if textlink != "manny_the_frenchie"
          puts "not manny"
          @b.goto("http://instagram.com/#{textlink}")
          #if @b.span(:class=>'_phrgb').text.to_i > 20 && @b.button(:text=>'Follow').present?
          if @b.button(:text=>'Follow').present?
              @b.button(:text=>'Follow').when_present.click
              #@b.button(:text=>'Follow').wait_while_present
              #Watir::Browser.back
              puts "FOLLOWED #{textlink}"
              follows+=1
              #@b.browser.back
              next
              #@b.a(:class=>'_ebwb5').wait_until_present
              #@b.goto("http://instagram.com/baby.beckham")
            else
              puts "NOT A VALID FOLLOW"
              #@b.browser.back
            #@b.a(:class=>'_ebwb5').wait_until_present
            next
          end
        else
          puts "orig poster"
        end
        index+=1
    end
  end
end

And(/^I should be redirected to the homepage$/) do
  sleep 5
  puts @b.url
  expect(@b.url).to eq("http://127.0.0.1:1337/")
end

And(/^I enter an invalid image$/) do
    @b.text_field(:name => 'pic').set 'I AM NOT AN IMAGE'
    sleep 7
end

And(/^I enter a valid image$/) do
    @b.text_field(:name => 'pic').set 'https://38.media.tumblr.com/avatar_7457d36dfb82_128.png'
    sleep 5
end

And(/^I should see an inavalid image error message$/) do
    picError = @b.element(:id => 'picError').present?
    puts picError
    sleep 3
    expect(picError).to be true
end

And(/^I should not see an image error message$/) do
    picError = @b.element(:id => 'picError').present?
    puts picError
    sleep 3
    expect(picError).to be false
end
