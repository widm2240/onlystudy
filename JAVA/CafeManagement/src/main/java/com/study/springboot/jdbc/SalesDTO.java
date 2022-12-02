package com.study.springboot.jdbc;

import lombok.Data;

@Data
public class SalesDTO {
	private String mobile;
	private String menu;
	private int qty;
	private int price;
	private String created;
}
