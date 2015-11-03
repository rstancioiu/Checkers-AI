
import java.util.Map;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;


public class Game implements Runnable{
    private String player1;
    private String player2;
    private String query1,query2;
    private int[][] table = new int[10][10];
    private Board board;
    
    public Game(String player1,String player2) {
        this.player1=player1;
        this.player2=player2;
        init();
        start();
    }

    private void init(){
        if(player1.equals("IA Random"));
            query1="play_random(1,MOVE)";
        if(player2.equals("IA Random"));
            query2="play_random(0,MOVE)";
    }
    
    private void start(){
        Query q1=new Query("consult", new Term[]{new Atom("C:\\cygwin64\\home\\Afkid\\GitHub\\Game_prolog\\IA\\board.pl")});
        System.out.println((q1.hasSolution() ? "succeeded" : "failed") );
        updateTable();
        board = new Board(table);
    }
    
    private void updateTable(){
        String t2="board(B)";
        Query q2=new Query(t2);
        while(q2.hasMoreSolutions()){
            Map<String,Term> s2=q2.nextSolution();
            String s=s2.get("B").toString();
            int cnt=0;
            for(int i=0;i<s.length();++i)
            {
                if(s.charAt(i)>='0' && s.charAt(i)<='4')
                {
                    table[cnt/10][cnt%10]=s.charAt(i)-'0';
                    cnt++;
                }
            }
        }
    }
    
    public void run() {
        boolean t=false;
        for(;;){
            String str;
            if(t) str=query1;
            else str=query2;
            Query q3=new Query(str);
            Map<String,Term> s3=q3.oneSolution();
            updateTable();
            board.update(table);
            try {
                Thread.sleep(1000);                 //1000 milliseconds is one second.
                } catch(InterruptedException ex) {
                 Thread.currentThread().interrupt();
            }
            t=!t;
        }
    }
}
