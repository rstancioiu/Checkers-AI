#ifndef BOARD_H
#define BOARD_H

#include <QMainWindow>
#include <QTableWidget>
#include <QPushButton>
#include <QSignalMapper>
#include <string>

class Board : public QMainWindow
{
    Q_OBJECT

public:
    explicit Board(QString white, QString black);
    ~Board();
    void Board::Paint();

private:
    void Board::drawPiece(int x,int y,std::string color);
    void Board::clearCell(int x,int y);
    void Board::initBoard();
    QTableWidget* tableWidget;
    QPushButton* move;
    int sizeTable;
private slots:
     void handleButtonMove();
};

#endif // Board_H
