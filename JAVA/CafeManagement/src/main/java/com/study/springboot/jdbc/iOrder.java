package com.study.springboot.jdbc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface iOrder {
	void addOrder(String m, String name, int cnt, int price);
	ArrayList<SalesDTO> getSalesList(String startd, String end);
	int getTotal(String startd, String end);
}
