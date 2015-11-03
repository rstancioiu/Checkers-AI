
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
        if (player2.equals("IA Random"))
            query2 = "play_random(0,MOVE)";
        else if (player2.equals("User"))
            query2 = "display_all_moves(0,MOVE)";
    }

    private void start() {
        Query q1 = new Query("consult", new Term[] {
                             new Atom("C:\\cygwin64\\home\\Afkid\\GitHub\\Game_prolog\\IA\\board.pl") });
        System.out.println((q1.hasSolution() ? "succeeded" : "failed"));
        initTable();
        updateTablePieces();
        board = new Board(pieces, table, this);
    }

    private void initTable() {
        for (int i = 0; i < N; ++i)
            for (int j = 0; j < N; ++j)
                table[i][j] = (i + j) % 2;
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

    public void run() {
        change = false;
        String str;
        for (;;) {
            if (change)
                str = query1;
            else
                str = query2;
            if (!str.equals("display_all_moves(1,MOVE)") && !str.equals("display_all_moves(0,MOVE)")) {
                Query q = new Query(str);
                Map<String, Term> s = q.oneSolution();
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
                board.update(pieces, table);
                done = new CountDownLatch(1);
                try {
                    loop = done.await(30, TimeUnit.SECONDS);
                } catch (InterruptedException e) {
                }
                initTable();
                updateTablePieces();
                board.update(pieces, table);
            }
            try {
                Thread.sleep(1000); //1000 milliseconds is one second.
            } catch (InterruptedException ex) {
                Thread.currentThread().interrupt();
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
