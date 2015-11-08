set path=C:\Program Files\swipl\bin;%path%;C:\Program Files\Java\jdk1.7.0_45\bin;
cd Gui
javac -cp "C:\Program Files\swipl\lib\jpl.jar;." Board.java Game.java Menu.java Main.java
java -cp "C:\Program Files\swipl\lib\jpl.jar;." Main