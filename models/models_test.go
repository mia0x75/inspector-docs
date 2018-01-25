package models

func test() {
	// 断言
	if db, ok := conn.(*gorm.DB); ok {
		user := &models.User{
			Login:        "mxu",
			Password:     "123",
			Status:       1,
			Name:         "xumiao",
			Email:        "email@163.com",
			Avator:       "",
			CreationDate: time.Now(),
		}

		r := db.Create(&user)
		fmt.Println(r)

		server := &models.Server{
			Host:         2130706433,
			Port:         3306,
			User:         "ID_XUMIAO",
			Password:     "b13(zHYQB7",
			Status:       1,
			CreationDate: time.Now(),
		}

		db.Create(&server)

		slave := &models.Slave{
			ServerId:     1,
			Host:         2130706433,
			Port:         3306,
			User:         "ID_XUMIAO",
			Password:     "b13(zHYQB7",
			Status:       1,
			CreationDate: time.Now(),
		}

		db.Create(&slave)

		o1 := &models.Option{
			Name:  "listen",
			Value: "0.0.0.0",
		}
		o2 := &models.Option{
			Name:  "port",
			Value: "1234",
		}

		db.Create(&o1)
		db.Create(&o2)

		ticket := &models.Ticket{
			ServerId:     1,
			Subject:      "为某个项目新建表",
			Content:      "CREATE TABLE t1 (id INT);",
			UserId:       1,
			ReviewerId:   2,
			Status:       1,
			CreationDate: time.Now(),
		}

		db.Create(&ticket)

		rule := &models.Rule{
			Name:        "select-without-limit",
			Description: "检查查询语句是否限制返回行",
			Valid:       1,
			Mandatory:   1,
		}

		db.Create(&rule)

		relation := &models.Relation{
			TaxonomyId:   1,
			AncestorId:   2,
			DescendantId: 3,
			CreationDate: time.Now(),
		}

		db.Create(&relation)

		taxonomy := &models.Taxonomy{
			Name:        "user-to-reviewer",
			Description: "用户到审核者的对应关系",
		}

		db.Create(&taxonomy)

		role := &models.Role{
			Name:        "guest",
			Description: "访客，没有任何权限，只能停留在登录页面",
		}

		db.Create(&role)
	}
}

