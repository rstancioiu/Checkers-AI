#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPushButton>
#include <QTextEdit>
#include <algorithm>
#include <string>
#include "board.h"

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    void initButtons();
    void paint();
    QPushButton* start;
    QPushButton* left[3];
    QPushButton* right[3];
    QTextEdit* center[3];
    Board* board;
    QSignalMapper mapper;
    int sizeTable;
private slots:
    void handleButtonStart();
    void handleButton(int x);
};

#endif // MAINWINDOW_H
