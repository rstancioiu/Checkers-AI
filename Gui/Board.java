import java.awt.Color;
import java.awt.Cursor;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Point;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.HashMap;
import java.util.Map;
import javax.swing.JOptionPane;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class Board extends JFrame {

    static final int N = 10;
    private JLabel[] labelsWhite = new JLabel[20];
    private JLabel[] labelsBlack = new JLabel[20];
    private ImageIcon black, white,whitequeen,blackqueen;
    private JPanel canvasBoard;
    private int clicked;
    private Point start,end;
    Map<Integer, Integer> map = new HashMap<Integer, Integer>();
    private int[][] table,pieces;
    private Game game;

    public Board(int[][] table,int [][] pieces, Game game) {
        this.table = table;
        this.pieces= pieces;
        this.game=game;
        clicked=0;
        configure();
        createAndShowGUI(); 
    }

    private void createAndShowGUI() {
        setTitle("Board");

        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        this.addWindowListener(new java.awt.event.WindowAdapter() {
            @Override
            public void windowClosing(java.awt.event.WindowEvent windowEvent) {
                game.m.stop();
            }
        });

        addComponentsToPane();

        setSize(600, 600);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    private void configure() {
        black = new ImageIcon("../Photos/black.png");
        Image img = black.getImage();
        Image newimgblack = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        black = new ImageIcon(newimgblack);
        white = new ImageIcon("../Photos/white.png");
        img = white.getImage();
        Image newimgwhite = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        white = new ImageIcon(newimgwhite);
        whitequeen = new ImageIcon("../Photos/white_queen.png");
        img = whitequeen.getImage();
        Image newimgwhitequeen = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        whitequeen = new ImageIcon(newimgwhitequeen);
        blackqueen = new ImageIcon("../Photos/black_queen.png");
        img = blackqueen.getImage();
        Image newimgblackqueen = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        blackqueen = new ImageIcon(newimgblackqueen);
    }

    private void addComponentsToPane() {
        canvasBoard=new CanvasBoard();
        canvasBoard.addMouseMotionListener(new MouseMotionListener() {
            @Override
            public void mouseMoved(MouseEvent e) {
                Point p = e.getPoint();
                int x = 40,y = 20,distx = 50,disty = 50;
                int ex=(int)((p.getX()-x)/distx);
                int ey=(int)((-p.getY()+520)/disty);
                if(ex>=0 && ex<=9 && ey>=0 && ey<=9){
                    if(pieces[ey][ex]!=0){
                        Cursor cursor = Cursor.getPredefinedCursor(Cursor.HAND_CURSOR);
                        setCursor(cursor);
                    } else {
                        Cursor cursor = Cursor.getDefaultCursor();
                        setCursor(cursor);
                    }
                }
            }
            @Override
            public void mouseDragged(MouseEvent e) {}
        });
        canvasBoard.addMouseListener(new MouseListener() {
            @Override
            public void mouseReleased(MouseEvent e) {
            }
            @Override
            public void mousePressed(MouseEvent e) {
            }
            @Override
            public void mouseExited(MouseEvent e) {
            }
            @Override
            public void mouseEntered(MouseEvent e) {
            }
            @Override
            public void mouseClicked(MouseEvent e) {
                Point p = e.getPoint();
                int x = 40,y = 20,distx = 50,disty = 50;
                if(clicked>=1){
                    end=p;
                    int sx=(int)((start.getX()-x)/distx);
                    int sy=(int)((-start.getY()+520)/disty);
                    int ex=(int)((end.getX()-x)/distx);
                    int ey=(int)((-end.getY()+520)/disty);
                    System.out.println(sx+" "+sy+" "+ex+" "+ey);
                    if(sx!=sy || ex!=ey)
                        game.sendQuery(sx,sy,ex,ey);
                    start=end;
                }
                else{
                    start=p;
                }
                clicked++;
            }
        });
        getContentPane().add(canvasBoard);
    }

    public void update(int[][] pieces,int[][] table) {
        this.table=table;
        this.pieces=pieces;
        canvasBoard.repaint();
    }

    class CanvasBoard extends JPanel {

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            Graphics2D g2d = (Graphics2D) g;
            int x = 40,y = 20,distx = 50,disty = 50;
            for (int i = N-1; i >=0; --i) {
                x = 40;
                for (int j = 0; j < N; ++j) {
                    if (table[i][j]==0) {
                        g2d.setColor(new Color(204, 102, 0));
                    } else if(table[i][j]==1){
                        g2d.setColor(new Color(204, 204, 0));
                    } else if(table[i][j]==2){
                        g2d.setColor(Color.green);
                    }
                    g2d.fillRect(x, y, distx, disty);
                    g2d.setColor(Color.black);
                    g2d.drawRect(x, y, distx, disty);
                    x+=distx;
                }
                y+= disty;
            }
            x = 20;
            y = 50;
            for (int i = 0; i < N; ++i) {
                String s = String.valueOf(10 - i);
                g2d.drawString(s, x, y);
                y += disty;
            }
            x = 10 + distx;
            y -= 10;
            for (int i = 0; i < N; ++i) {
                String s = String.valueOf(i + 1);
                g2d.drawString(s, x, y);
                x += distx;
            }
            x = 40;
            y = 20;
            distx = 50;
            disty = 50;
            for (int i = N - 1; i >= 0; --i) {
                x = 40;
                for (int j = 0; j < N; ++j) {
                    if (pieces[i][j] == 1) {
                        g2d.drawImage(white.getImage(), x + 7, y + 7, 36, 36, null);
                    } else if (pieces[i][j] == 2) {
                        g2d.drawImage(black.getImage(), x + 7, y + 7, 36, 36, null);
                    } else if (pieces[i][j] == 3) {
                        g2d.drawImage(whitequeen.getImage(), x + 7, y + 7, 36, 36, null);
                    } else if (pieces[i][j] == 4) {
                        g2d.drawImage(blackqueen.getImage(), x + 7, y + 7, 36, 36, null);
                    }
                    x += distx;
                }
                y += disty;
            }
        }
    }
}
