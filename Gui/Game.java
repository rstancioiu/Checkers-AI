
import java.util.Map;

import java.util.concurrent.CountDownLatch;

import java.util.concurrent.TimeUnit;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;


public class Game implements Runnable {
    private CountDownLatch done;
    static final int N = 10;
    private String player1;
    private String player2;
    private boolean loop;
    private boolean change;
    private String query1, query2;
    private int[][] pieces = new int[N][N];
    private int[][] table = new int[N][N];
    private Board board;

    public Game(String player1, String player2) {
        this.player1 = player1;
        this.player2 = player2;
        init();
        start();
    }

    private void init() {
        if (player1.equals("IA Random"))
            query1 = "play_random(1,MOVE)";
        else if (player1.equals("User"))
            query1 = "display_all_moves(1,MOVE)";
        else if (player1.equals("IA MiniMax"))
            query1 = "play_minimax(2,1,MOVE)";
        else if (player1.equals("IA MiniMaxS"))
            query1 = "play_minimax_special(2,1,MOVE)";
        if (player2.equals("IA Random"))
            query2 = "play_random(0,MOVE)";
        else if (player2.equals("User"))
            query2 = "display_all_moves(0,MOVE)";
        else if (player2.equals("IA MiniMax"))
            query2 = "play_minimax(2,0,MOVE)";
        else if (player2.equals("IA MiniMaxS"))
            query2 = "play_minimax_special(2,0,MOVE)";
    }

    private void start() {
        Query q1 = new Query("consult", new Term[] {
                             new Atom("../IA/main.pl") });
        System.out.println((q1.hasSolution() ? "succeeded" : "failed"));
        initTable();
        initPieces();
        wait(200);
        updateTablePieces();
        board = new Board(pieces, table, this);
    }

    private void initTable() {
        for (int i = 0; i < N; ++i)
            for (int j = 0; j < N; ++j)
                table[i][j] = (i + j) % 2;
    }

    private void initPieces(){
        String t1 = "init";
        Query q1 = new Query(t1);
        System.out.println((q1.hasSolution() ? "Init realised" : "Init failed"));
    }

    private void updateTablePieces() {
        String t2 = "board(B)";
        Query q2 = new Query(t2);
        while (q2.hasMoreSolutions()) {
            Map<String, Term> s2 = q2.nextSolution();
            String s = s2.get("B").toString();
            int cnt = 0;
            for (int i = 0; i < s.length(); ++i) {
                if (s.charAt(i) >= '0' && s.charAt(i) <= '4') {
                    pieces[cnt / N][cnt % N] = s.charAt(i) - '0';
                    cnt++;
                }
            }
        }
    }

    private boolean checkWin(){
        String win1="check_win_player(0)"; //black
        String win2="check_win_player(1)"; //white
        Query q1 = new Query(win1);
        Query q2 = new Query(win2);
        if(q1.hasSolution()){
            System.out.println("Player black won");
            for(int i=0;i<N;++i){
                for(int j=0;j<N;++j){
                    if(pieces[i][j]==2 || pieces[i][j]==4)
                        table[i][j]=2;
                    else
                        table[i][j]=(i+j)%2;
                }
            }
            return true;
        }
        if(q2.hasSolution()){
            System.out.println("Player white won");
            for(int i=0;i<N;++i){
                for(int j=0;j<N;++j){
                    if(pieces[i][j]==1 || pieces[i][j]==3)
                        table[i][j]=2;
                    else
                        table[i][j]=(i+j)%2;
                }
            }
            return true;
        }
        return false;
    }

    private void wait(int waiting)
    {
        try {
            Thread.sleep(waiting); //1000 milliseconds is one second.
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
        }
    }

    public void run() {
        change = false;
        String str;
        for (;;) {
            wait(200);
            if (change)
                str = query1;
            else
                str = query2;
            if (!str.equals("display_all_moves(1,MOVE)") && !str.equals("display_all_moves(0,MOVE)")) {
                Query q = new Query(str);
                Map<String, Term> s = q.oneSolution();
                wait(200);
                updateTablePieces();
                board.update(pieces, table);
            } else {
                Query q = new Query(str);
                while (q.hasMoreSolutions()) {
                    Map<String, Term> s = q.nextSolution();
                    String st = s.get("MOVE").toString();
                    int a = 0, b = 0, cnt = 0;
                    for (int i = 0; i < st.length(); ++i) {
                        if (st.charAt(i) >= '0' && st.charAt(i) <= '9') {
                            if (cnt == 0)
                                a = st.charAt(i) - '0';
                            else if (cnt == 1) {
                                b = st.charAt(i) - '0';
                                table[b][a] = 2;
                                System.out.print(a+" "+b+"   ");
                            }
                            cnt = (cnt + 1) % 2;
                        }
                    }
                    System.out.println();
                }
                wait(200);
                board.update(pieces, table);
                done = new CountDownLatch(1);
                try {
                    loop = done.await(30, TimeUnit.SECONDS);
                } catch (InterruptedException e) {
                }
                initTable();
                wait(200);
                updateTablePieces();
                board.update(pieces, table);
            }
            wait(200);
            if(checkWin()){
                board.update(pieces, table);
                break;
            }
            change = !change;
        }
    }

    public void sendQuery(int sx,int sy,int ex,int ey){
        String str;
        if(change){
            str="make_user_move(1,"+sx+","+sy+","+ex+","+ey+")";
        }else{
            str="make_user_move(0,"+sx+","+sy+","+ex+","+ey+")";
        }
        Query q = new Query(str);
        Map<String, Term> s = q.oneSolution();
        System.out.println("sent");
        done.countDown();
    }
}
