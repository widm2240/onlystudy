package com.study.springboot;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.jdbc.MenuDTO;
import com.study.springboot.jdbc.SalesDTO;
import com.study.springboot.jdbc.iCafe;
import com.study.springboot.jdbc.iOrder;

@Controller
public class MyController {
	@Autowired
	private iCafe cafe;
	@Autowired
	private iOrder order;
	
	@RequestMapping("/")
	public @ResponseBody String root() {
		return "CafeManagement";
	}
	@RequestMapping("/menu") public String doMenu() { return "menu"; }
	@RequestMapping("/order") public String doOrder() { return "order";	}
	@RequestMapping("/sales") public String doSales() {	return "sales";	}

	@RequestMapping("/loadMenu")
	@ResponseBody
	public String doLoadMenu() {
		System.out.println("doLoadMenu");
		ArrayList<MenuDTO> mdto = cafe.loadMenu();
		System.out.println("JSONArray making");
		JSONArray ja = new JSONArray();
		for(int i=0; i<mdto.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("id",mdto.get(i).getId());
			jo.put("name",mdto.get(i).getName());
			jo.put("price",mdto.get(i).getPrice());
			ja.add(jo);
		}
		System.out.println(ja.size());
		return ja.toJSONString();
//		return "doLoadMenu";
	}
	@RequestMapping("/addMenu")
	@ResponseBody
	public String doAddMenu(HttpServletRequest req) {
		String name=req.getParameter("name");
		int price=Integer.parseInt(req.getParameter("price"));
		cafe.addMenu(name, price);
		return "ok";
	}
	@RequestMapping("/deleteMenu")
	@ResponseBody
	public String doDeleteMenu(HttpServletRequest req) {
		int id=Integer.parseInt(req.getParameter("id"));
		cafe.deleteMenu(id);
		return "ok";
	}
	@RequestMapping("/updateMenu")
	@ResponseBody
	public String doUpdateMenu(HttpServletRequest req) {
		int id=Integer.parseInt(req.getParameter("id"));
		String name=req.getParameter("name");
		int price=Integer.parseInt(req.getParameter("price"));
		cafe.updateMenu(id, name, price);
		return "ok";
	}
	@RequestMapping("/addOrder")
	@ResponseBody
	public String doAddOrder(HttpServletRequest req) {
		order.addOrder(req.getParameter("mobile"), 
					   req.getParameter("menu"), 
					   Integer.parseInt(req.getParameter("qty")), 
					   Integer.parseInt(req.getParameter("price")));
		return "ok";
	}
	
	@RequestMapping("/getSalesList")
	@ResponseBody
	public String doGetSalesList(HttpServletRequest req) {
		ArrayList<SalesDTO> sdto=order.getSalesList(req.getParameter("start"), req.getParameter("end"));
		JSONArray ja = new JSONArray();
		for(int i=0; i<sdto.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("mobile",sdto.get(i).getMobile());
			jo.put("menu",sdto.get(i).getMenu());
			jo.put("qty", sdto.get(i).getQty());
			jo.put("price",sdto.get(i).getPrice());
			jo.put("created",sdto.get(i).getCreated());
			ja.add(jo);
		}
		System.out.println(ja.size());
		return ja.toJSONString();
	}
	
	@RequestMapping("/getTotal")
	@ResponseBody
	public String doGetTotal(HttpServletRequest req) {
		int total=order.getTotal(req.getParameter("start"), req.getParameter("end"));
		return Integer.toString(total);
	}
}
