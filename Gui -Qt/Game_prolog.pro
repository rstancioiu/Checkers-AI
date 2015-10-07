#-------------------------------------------------
#
# Project created by QtCreator 2015-10-06T19:06:13
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Game_prolog
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui

CONFIG += link_pkgconfig
PKGCONFIG += swipl
