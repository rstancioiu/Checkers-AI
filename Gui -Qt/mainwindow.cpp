#include "mainwindow.h"
#include "board.h"
#include <QPushButton>
#include <QWidget>


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent)
{
    this->resize(600,500);
    choose = new QPushButton("Choose",this);
    choose->setGeometry(QRect(260,400,80,40));
    choose->setEnabled(true);
    connect(choose, SIGNAL (released()), this, SLOT (handleButtonChoose()));
}

void MainWindow::handleButtonChoose()
{
    board = new Board(this);
    board->show();
    hide();
}

MainWindow::~MainWindow()
{
}

