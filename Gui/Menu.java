import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.Border;

public class Menu extends JFrame{

    static final int SIZE=4;    
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
        left[0] = new JButton("IA Random");
        right[0] = new JButton("IA Random");
        left[1] = new JButton("User");
        right[1] = new JButton("User");
        left[2] = new JButton("IA MiniMax");
        right[2] = new JButton("IA MiniMax");
        left[3] = new JButton("IA MiniMaxS");
        right[3] = new JButton("IA MiniMaxS");
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
        start.setBounds(250,500,100,50);
        start.addActionListener(new ListenerStart());
        left[0].setBounds(20,100,120,50);
        left[1].setBounds(20,180,120,50);
        left[2].setBounds(20,260,120,50);
        left[3].setBounds(20,340,120,50);
        left[0].addActionListener(new ListenerLeft());
        left[1].addActionListener(new ListenerLeft());
        left[2].addActionListener(new ListenerLeft());
        left[3].addActionListener(new ListenerLeft());
        right[0].setBounds(460,100,120,50);
        right[1].setBounds(460,180,120,50);
        right[2].setBounds(460,260,120,50);
        right[3].setBounds(460,340,120,50);
        right[0].addActionListener(new ListenerRight());
        right[1].addActionListener(new ListenerRight());
        right[2].addActionListener(new ListenerRight());
        right[3].addActionListener(new ListenerRight());
        center[0].setBounds(150,250,100,60);
        center[0].setHorizontalAlignment(JTextField.CENTER);
        center[0].setEditable(false);
        center[1].setBounds(270,250,60,60);
        center[1].setHorizontalAlignment(JTextField.CENTER);
        center[1].setEditable(false);
        center[2].setBounds(350,250,100,60);
        center[2].setHorizontalAlignment(JTextField.CENTER);
        center[2].setEditable(false);
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
        
        setSize(600, 600);
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
                Thread game=new Thread(new Game(center[0].getText(),center[2].getText()));
                game.start();
            }
        }
    }
}
