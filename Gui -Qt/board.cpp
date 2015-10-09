#include "board.h"
#include <QPushButton>
#include <QTableWidget>
#include <QTableWidgetItem>
#include <QDesktopWidget>
#include <QString>
#include <QRect>
#include <QHeaderView>
#include <QFont>
#include <QLabel>
#include <QImageReader>
#include <QImage>
#include <QFile>

Board::Board(QString white,QString black) :
    QMainWindow(0)
{
    sizeTable=10;
    QFile qss(":/stylesheets/board.qss");
    qss.open(QFile::ReadOnly);
    this->setStyleSheet(qss.readAll());
    qss.close();
    Paint();
}

void Board::Paint()
{
    this->resize(600,600);
    initBoard();
    move = new QPushButton("Move",this);
    move->setFont(QFont("red"));
    move->setGeometry(QRect(50,440,80,40));
    move->setEnabled(true);
    connect(move, SIGNAL (released()), this, SLOT (handleButtonMove()));
    for(int i=0;i<sizeTable;++i)
    {
        for(int j=0;j<sizeTable;++j)
        {
            if(i<=3 && ((i+j)%2==1))
                drawPiece(i,j,"white");
            else if(i>5 && ((i+j)%2==1))
                drawPiece(i,j,"black");
        }
    }
}

void Board::initBoard()
{
    tableWidget = new QTableWidget(this);
    tableWidget->setRowCount(sizeTable);
    tableWidget->setColumnCount(sizeTable);
    tableWidget->verticalHeader()->setVisible(false);
    tableWidget->horizontalHeader()->setVisible(false);
    tableWidget->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    tableWidget->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    tableWidget->verticalHeader()->sectionResizeMode(QHeaderView::Fixed);
    tableWidget->horizontalHeader()->sectionResizeMode(QHeaderView::Fixed);
    tableWidget->verticalHeader()->setDefaultSectionSize(40);
    tableWidget->horizontalHeader()->setDefaultSectionSize(40);
    tableWidget->setFixedSize(406,406);
    tableWidget->setGeometry(QRect(20,20,50+406,50 + 406));
    for(int i=0;i<sizeTable;++i)
    {
        for(int j=0;j<sizeTable;++j)
        {
            if((i+j)%2==1)
            {
                QTableWidgetItem* color = new QTableWidgetItem();
                color->setBackground(QBrush(QColor(162,117,27)));
                tableWidget->setItem(i,j,color);
            }
            else
            {
                QTableWidgetItem* color = new QTableWidgetItem();
                color->setBackground(QBrush(QColor(187,199,17)));
                tableWidget->setItem(i,j,color);
            }
        }
    }
}

void Board::handleButtonMove()
{
    int x=rand()%10;
    int y=rand()%10;
    clearCell(x,y);
    x=rand()%10;
    y=rand()%10;
    drawPiece(x,y,"black");
}

void Board::drawPiece(int x,int y,std::string color)
{
    QPixmap pix=QPixmap(QString::fromStdString(":/images/"+color+".png"));
    QPixmap resPix = pix.scaled(30,30, Qt::IgnoreAspectRatio, Qt::SmoothTransformation);
    QLabel *label =new QLabel();
    label->setPixmap(resPix);
    label->setAlignment(Qt::AlignCenter);
    tableWidget->setCellWidget(x,y,label);
}

void Board::clearCell(int x,int y)
{
    QLabel *label=new QLabel("");
    tableWidget->setCellWidget(x,y,label);
}


Board::~Board()
{
}


