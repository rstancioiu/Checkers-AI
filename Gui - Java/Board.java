import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;

import java.util.HashMap;
import java.util.Map;

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
    Map<Integer, Integer> map = new HashMap<Integer, Integer>();
    private int[][] table;

    public Board(int[][] table) {
        this.table = table;
        configure();
        createAndShowGUI(); 
    }

    private void createAndShowGUI() {
        setTitle("Board");

        setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);

        addComponentsToPane();

        setSize(600, 600);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    private void configure() {
        black = new ImageIcon("e://Photos/black.png");
        Image img = black.getImage();
        Image newimgblack = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        black = new ImageIcon(newimgblack);
        white = new ImageIcon("e://Photos/white.png");
        img = white.getImage();
        Image newimgwhite = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        white = new ImageIcon(newimgwhite);
        whitequeen = new ImageIcon("e://Photos/white_queen.png");
        img = whitequeen.getImage();
        Image newimgwhitequeen = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        whitequeen = new ImageIcon(newimgwhitequeen);
        blackqueen = new ImageIcon("e://Photos/black_queen.png");
        img = blackqueen.getImage();
        Image newimgblackqueen = img.getScaledInstance(36, 36, java.awt.Image.SCALE_SMOOTH);
        blackqueen = new ImageIcon(newimgblackqueen);
    }

    private void addComponentsToPane() {
        canvasBoard=new CanvasBoard();
        getContentPane().add(canvasBoard);
    }

    public void update(int[][] table) {
        this.table=table;
        canvasBoard.repaint();
    }

    class CanvasBoard extends JPanel {

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            Graphics2D g2d = (Graphics2D) g;
            int x = 40;
            int y = 20;
            int distx = 50;
            int disty = 50;
            System.out.println("##############################");
            System.out.println("##############################");
            for(int i=0;i<10;++i)
            {
                for(int j=0;j<10;++j)
                    System.out.print(table[i][j]+" ");
                System.out.print("\n");
            }
            for (int i = 0; i < N; ++i) {
                y = 20;
                for (int j = 0; j < N; ++j) {
                    if ((i + j) % 2 == 0) {
                        g2d.setColor(new Color(204, 102, 0));
                    } else {
                        g2d.setColor(new Color(204, 204, 0));
                    }
                    g2d.fillRect(x, y, distx, disty);
                    g2d.setColor(Color.black);
                    g2d.drawRect(x, y, distx, disty);
                    y += disty;
                }
                x += distx;
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
                    if (table[i][j] == 1) {
                        g2d.drawImage(white.getImage(), x + 7, y + 7, 36, 36, null);
                    } else if (table[i][j] == 2) {
                        g2d.drawImage(black.getImage(), x + 7, y + 7, 36, 36, null);
                    }
                    else if (table[i][j] == 3) {
                        g2d.drawImage(whitequeen.getImage(), x + 7, y + 7, 36, 36, null);
                    } else if (table[i][j] == 4) {
                        g2d.drawImage(blackqueen.getImage(), x + 7, y + 7, 36, 36, null);
                    }
                    x += distx;
                }
                y += disty;
            }
        }
    }
}
