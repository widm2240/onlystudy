# -*- coding: utf-8 -*-
from time import sleep

print("프로젝트 파일 작성의 모범 답안입니다.")

def process_data(data):
    print("1단계: 데이터 전처리 함수를 실행합니다. ")
    modified_data = "3단계: " + data + "가 수정 완료 되었습니다."
    sleep(3)
    print("2단계: 데이터 전처리가 끝났습니다.")
    return modified_data

def main():
    data = "빅쿼리에서 온 데이터"
    print(data)
    modified_data = process_data(data)
    print(modified_data)

if __name__ == "__main__":
    main()