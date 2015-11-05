import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.JLabel;
import java.awt.Image;
import java.awt.Font;
import javax.swing.ImageIcon;

public class Menu extends JFrame{

    static final int SIZE=5;    
    JButton start;
    JButton left[]=new JButton[SIZE];
    JButton right[]=new JButton[SIZE];
    JTextField center[]= new JTextField[3];

    public Menu() {
        createAndShowGUI();//call method to create gui
    }

    private void createAndShowGUI() {
        setTitle("Menu");

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    
        JPanel panel=new JPanel();
        panel.setBounds(800, 800, 200, 100);
        panel.setLayout(null);
        
        start = new JButton("Start");
        left[0] = new JButton("User");
        right[0] = new JButton("User");
        left[1] = new JButton("IA Random");
        right[1] = new JButton("IA Random");
        left[2] = new JButton("IA MiniMax");
        right[2] = new JButton("IA MiniMax");
        left[3] = new JButton("IA MiniMaxS");
        right[3] = new JButton("IA MiniMaxS");
        left[4] = new JButton("IA AlphaBeta");
        right[4] = new JButton("IA AlphaBeta");
        center[0]= new JTextField(""){
            @Override public void setBorder(Border border) {
                // No!
            }
        };
        center[1]= new JTextField("VS"){
            @Override public void setBorder(Border border) {
                // No!
            }
        };
        center[2]= new JTextField(""){
            @Override public void setBorder(Border border) {
                // No!
            }
        };;

        ImageIcon menuimg = new ImageIcon("../Photos/menu.png");
        JLabel info = new JLabel("");
        info.setIcon(menuimg);
        info.setBounds(120,30,400,144);
        panel.add(info);

        start.setBounds(250,560,100,50);
        start.addActionListener(new ListenerStart());
        left[0].setBounds(20,200,110,40);
        left[1].setBounds(20,270,110,40);
        left[2].setBounds(20,340,110,40);
        left[3].setBounds(20,410,110,40);
        left[4].setBounds(20,480,110,40);
        left[0].addActionListener(new ListenerLeft());
        left[1].addActionListener(new ListenerLeft());
        left[2].addActionListener(new ListenerLeft());
        left[3].addActionListener(new ListenerLeft());
        left[4].addActionListener(new ListenerLeft());
        right[0].setBounds(460,200,110,40);
        right[1].setBounds(460,270,110,40);
        right[2].setBounds(460,340,110,40);
        right[3].setBounds(460,410,110,40);
        right[4].setBounds(460,480,110,40);
        right[0].addActionListener(new ListenerRight());
        right[1].addActionListener(new ListenerRight());
        right[2].addActionListener(new ListenerRight());
        right[3].addActionListener(new ListenerRight());
        right[4].addActionListener(new ListenerRight());
        center[0].setBounds(170,330,100,60);
        center[0].setHorizontalAlignment(JTextField.CENTER);
        center[0].setEditable(false);
        center[1].setBounds(270,330,60,60);
        center[1].setHorizontalAlignment(JTextField.CENTER);
        center[1].setEditable(false);
        center[2].setBounds(330,330,100,60);
        center[2].setHorizontalAlignment(JTextField.CENTER);
        center[2].setEditable(false);

        Font font = center[0].getFont();
        Font boldFont = new Font(font.getFontName(), Font.BOLD, font.getSize()+4);
        center[0].setFont(boldFont);
        center[1].setFont(boldFont);
        center[2].setFont(boldFont);
        panel.add(start);
        for(int i=0;i<SIZE;++i) {
            panel.add(left[i]);
            panel.add(right[i]);
            if(i<3){
                center[i].setOpaque(false);
                panel.add(center[i]);
            }
        }
        add(panel);
        
        setSize(600, 700);
        setLocationRelativeTo(null); 
        setVisible(true);
    }
    
    private class ListenerLeft implements ActionListener{
         public void actionPerformed(ActionEvent e) {
             center[0].setText(e.getActionCommand());
        }
    }
    private class ListenerRight implements ActionListener{
        public void actionPerformed(ActionEvent e){
            center[2].setText(e.getActionCommand());
        }
    }
    private class ListenerStart implements ActionListener{
        public void actionPerformed(ActionEvent e){
            if(!(center[0].getText().equals("") || center[2].getText().equals(""))) {
                Game runnable = new Game(center[0].getText(),center[2].getText());
                Thread game=new Thread(runnable);
                runnable.set_mother(game);
                game.start();
            }
        }
    }
}
