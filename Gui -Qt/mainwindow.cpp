#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QPushButton>
#include <QTableWidget>
#include <QTableWidgetItem>
#include <QDesktopWidget>
#include <QString>
#include <QRect>
#include <QHeaderView>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
   tableWidget(NULL)
{
    tableWidget = new QTableWidget(this);
    tableWidget->setRowCount(10);
    tableWidget->setColumnCount(10);
    tableWidget->verticalHeader()->setVisible(false);
    tableWidget->horizontalHeader()->setVisible(false);
    tableWidget->setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    tableWidget->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    tableWidget->verticalHeader()->sectionResizeMode(QHeaderView::Fixed);
    tableWidget->horizontalHeader()->sectionResizeMode(QHeaderView::Fixed);
    tableWidget->verticalHeader()->setDefaultSectionSize(40);
    tableWidget->horizontalHeader()->setDefaultSectionSize(40);
    tableWidget->setStyleSheet("QTableView {selection-background-color: red;}");
    tableWidget->setGeometry(QRect(50,50,400,400));

    //insert data
    tableWidget->setItem(0,1,new QTableWidgetItem("Salut"));
    this->resize(500,600);
}

MainWindow::~MainWindow()
{
}
