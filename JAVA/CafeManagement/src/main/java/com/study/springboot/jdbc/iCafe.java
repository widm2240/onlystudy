package com.study.springboot.jdbc;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface iCafe {
	ArrayList<MenuDTO> loadMenu();
	void addMenu(String name,int price);
	void deleteMenu(int id);
	void updateMenu(int id, String name,int price);
}
