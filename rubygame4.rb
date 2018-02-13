# Version 4

Shoes.app(title: "Dragons vs. Shoes", width: 800, height: 450) do

  # Hintergrundbild für den Startbildschirm
  image "background.png"



  # Button zum Starten des Spiels
  stack top: 300, left: 320 do
    button "PLAY", width: 100, height: 80 do   #button do -Ende Buttons Alles was im Stack drin ist

      # Klickt man auf den Button, verschwindet dieser und das Spiel beginnt
      clear button

      image "background022.png"      #evt. Bilddefinition zu Beginn festlegen Größe

      # Variablen


      # Spieler einfügen
      @drache = image "dragon.png", leftf: 15, top: 215   #@Instanzvariable überall zugreifen , global Instanzen

      # Position Spieler
      @y_achse = 215
      x_achse = 15

      # Spieler hoch und runter bewegen

      key = keypress  {|key|     #Variable key/Taste ect. keypress Funktion do und end oder geschweifte Klammer
        if (key == "w") and (@y_achse > 50)         #if key==up hoch und runter Taste
          @y_achse = @y_achse - 20    # Größe Schritte -20   Bedenke: Koordinatensystem
          @drache.move 15, @y_achse     #move Funktion beweg dich
        end
        if (key == "s") and (@y_achse < 385)    #Abstand von oben
          @y_achse = @y_achse + 20
          @drache.move 15, @y_achse
        end
      }



      # Punkte-Stand
      score = 0    #Zähler auf 0

      # Position Punkte-Zaehler
      @punkte = para "Rubies: #{score}/30", width: 110, :left => 15, :top => 10   #"para"" puts von shoes


      # Level
      level = "Level 1"

      # Level zählen
      @level = para level, width: 100, :left => 130, :top => 10

      # Leben zählen
      leben = 4

      # Leben einfügen
      @leben1 = image "leben.png", left: 600, top: 10  #sind in der oberen Leiste drin
      @leben2 = image "leben.png", left: 650, top: 10
      @leben3 = image "leben.png", left: 700, top: 10
      @leben4 = image "leben.png", left: 750, top: 10


      # Rubies einfügen
      x1 = 800  #Position auf der x-Achse
      every(3) do     #ruby-funktion  3 Sec.
        collected = false  #Ausgangszustand ich habe was eingesammelt-> falsch
        y2 = rand(400)   #Random
        bonus = image "ruby.png", left: x1, top: y2
        animation = animate(72) do |i|  #Variable animate=72 frame per second 24-normal Fernseh vielfaches i=iterator-durchläuft alle Funktion

          #Level 1
          if score<5
            score, collected = rubies_collected(bonus, score, collected, 2)
            animation.stop if x > 800  #CPU-Belastung Programm läuft nicht weiter     #else if
            animation.stop if
          #Level 2

          elsif score>=5 and score<10
            score, collected = rubies_collected(bonus, score, collected, 4)
            animation.stop if x > 800
          elsif

          #Level 3

          elsif score>=10 and score<20
            score, collected = rubies_collected(bonus, score, collected, 5)
            animation.stop if x > 800
          #Level 4
          else score>=20 and score<30
            score, collected = rubies_collected(bonus, score, collected, 7)
            animation.stop if x > 800
          end
        end


      end

      # Funktion Rubies sammeln
      def rubies_collected(bonus, score, collected, speed)
        x_bonus = bonus.left - speed    #    siehe Bild Laura-linke KanteBild
        bonus.move(x_bonus, bonus.top)
        @punkte.replace "Rubies: #{score}/30"  #punkt.replace Ruby Funktion deshalb Instanzvariable

        if ((bonus.left > 130 or bonus.left < 0) or bonus.top > (@y_achse + 75)) or (bonus.top + 60 < @y_achse)
          collected = false   #75, das Ruby 70+(Spielraum)5 , 60 Schuh

        else
          if collected == false   #Bedingungen
            collected = true
            score += 1
          end
        end

        return score, collected
      end


      # Enemies  werden definiert und Kollision festgelegt



      def collide(enemy, collision, leben, speed)
        x_enemy = enemy.left - speed
        enemy.move(x_enemy, enemy.top)



        # Wann kollidiert ein Enemy mit dem Spieler?          oben                        unten

        if ((enemy.left > 130 or enemy.left < 0) or (enemy.top > (@y_achse + 75)) or (enemy.top + 60 < @y_achse))
          collision = false      #Leben statt Score, collision statt collected


          # bei Kollision werden Leben abgezogen

        else
          if collision == false
            collision = true
            leben -=  1
            if leben == 3
              @leben4.hide() #Ruby-Funktion verstecke
            elsif leben == 2
              @leben3.hide()
            elsif leben == 1
              @leben2.hide()
            else
              @leben1.hide()
              if confirm("Game over. Play again?") #Ruby-Def.
                load('rubygamev4.rb', wrap=true)
                close()
              else
                close()
              end
            end
          end
        end


        if x_enemy == 0
          enemy = nil
        end


        return collision, leben
      end # Ende def collide





      # Collision
      x = 800
      every(3) do
        collision = false
        y1 = rand(400)
        enemy = image "shoes.png", :left => x , :top => y1

        animation2 = animate(72) do |x|

          #Erstes Level

          if score < 5

            collision, leben = collide(enemy, collision, leben, 3)
            animation2.stop if x > 800
          end


          #Zweites Level

          if score>= 5 and score<10
            @level.replace "Level 2"

            collision, leben = collide(enemy, collision, leben, 5)
            animation2.stop if x > 800
          end


          #Drittes Level

          if score>= 10 and score<20
            @level.replace "Level 3"
            collision, leben = collide(enemy, collision, leben, 7)
            animation2.stop if x > 800
          end


          if score>=20 and score<30
            @level.replace "Level 4"
            collision, leben = collide(enemy, collision, leben, 9)
            animation2.stop if x > 800
          end
        end

        if score>=30
          if confirm("Congratulations! You won! Play again?")
            load('rubygamev4.rb', wrap=true)
            close()
          else
            close()
          end

        end
      end




    end


  end # Ende Button

end # Ende Shoes.app do