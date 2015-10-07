#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTableWidget>
#include <QPushButton>
#include <string>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    void MainWindow::UpdateTable(int x,int y);
    void MainWindow::Paint();

private:
    void MainWindow::drawPiece(int x,int y,std::string color);
    void MainWindow::clearCell(int x,int y);
    QTableWidget* tableWidget;
    QPushButton* move;
    Ui::MainWindow* ui;
    int sizeTable;
private slots:
     void handleButtonMove();
};

#endif // MAINWINDOW_H
