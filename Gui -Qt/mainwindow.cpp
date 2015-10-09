#include "mainwindow.h"
#include "board.h"
#include <QPushButton>
#include <QWidget>
#include <QFile>
#include <cstdio>


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent)
{
    this->resize(600,600);
    QFile qss(":/stylesheets/mainwindow.qss");
    qss.open(QFile::ReadOnly);
    this->setStyleSheet(qss.readAll());
    qss.close();
    initButtons();
    paint();
}

void MainWindow::handleButtonStart()
{
    if(center[0]->toPlainText()!="" && center[2]->toPlainText()!="")
    {
        board = new Board(center[0]->toPlainText(),center[2]->toPlainText());
        board->show();
        hide();
    }
}


void MainWindow::initButtons()
{
    start = new QPushButton("Start",this);
    left[0] = new QPushButton("Player 1",this);
    right[0] = new QPushButton("Player 1",this);
    left[1] = new QPushButton("Player 2",this);
    right[1] = new QPushButton("Player 2",this);
    left[2] = new QPushButton("Player 3",this);
    right[2] = new QPushButton("Player 3",this);
    center[0] = new QTextEdit("",this);
    center[1] = new QTextEdit("VS",this);
    center[2] = new QTextEdit("",this);
}

void MainWindow::paint()
{
    start->setGeometry(QRect(250,500,100,50));
    start->setEnabled(true);
    connect(start, SIGNAL (released()), this, SLOT (handleButtonStart()));
    left[0]->setGeometry(QRect(20,100,120,50));
    left[1]->setGeometry(QRect(20,200,120,50));
    left[2]->setGeometry(QRect(20,300,120,50));
    right[0]->setGeometry(QRect(460,100,120,50));
    right[1]->setGeometry(QRect(460,200,120,50));
    right[2]->setGeometry(QRect(460,300,120,50));
    center[0]->setGeometry(QRect(150,250,100,60));
    center[1]->setGeometry(QRect(270,250,60,60));
    center[2]->setGeometry(QRect(350,250,100,60));
    for(int i=0;i<3;++i)
    {
        center[i]->setReadOnly(true);
        center[i]->setAlignment(Qt::AlignCenter);
        center[i]->viewport()->setAutoFillBackground(false);
        center[i]->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
        center[i]->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
        center[i]->setFrameStyle(QFrame::NoFrame);
    }

    connect(left[0], SIGNAL(clicked()), &mapper, SLOT(map()));
    mapper.setMapping(left[0],0);
    connect(left[1], SIGNAL(clicked()), &mapper, SLOT(map()));
    mapper.setMapping(left[1],1);
    connect(left[2], SIGNAL(clicked()), &mapper, SLOT(map()));
    mapper.setMapping(left[2],2);
    connect(right[0], SIGNAL(clicked()), &mapper, SLOT(map()));
    mapper.setMapping(right[0],3);
    connect(right[1], SIGNAL(clicked()), &mapper, SLOT(map()));
    mapper.setMapping(right[1],4);
    connect(right[2], SIGNAL(clicked()), &mapper, SLOT(map()));
    mapper.setMapping(right[2],5);

    connect(&mapper, SIGNAL(mapped(int)), this, SLOT(handleButton(int)));

}

void MainWindow::handleButton(int x)
{
    if(x<3) center[0]->setText(left[x]->text());
    else center[2]->setText(right[x-3]->text());
}

MainWindow::~MainWindow()
{
}

