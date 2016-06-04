package com.entities;

import java.math.BigDecimal;
import java.sql.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "platnosc")
public class Payment
{
	@Id
	@SequenceGenerator(name="platnosc_id_seq", sequenceName="platnosc_id_seq", allocationSize=1)
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="platnosc_id_seq")
	@Column(name="id", nullable=false)
	private int id;
	
	@ManyToOne
	@JoinColumn(name = "uzytkownik_id")
	private User user;
	
	@ManyToOne(optional = true)
	@JoinColumn(name = "wypozyczenie_id")
	private Rental rental;
	
	@Column(name = "rodzaj")
	private String type;
	
	@Column(name = "kwota", nullable = false)
	private BigDecimal amount;
	
	@Column(name = "data_wystawienia", nullable = false)
	private Date issueDate;
	
	@Column(name = "data_zaplacenia")
	private Date paymentDate;

	public Rental getRental()
	{
		return rental;
	}

	public void setRental(Rental rental)
	{
		this.rental = rental;
	}

	public String getType()
	{
		return type;
	}

	public void setType(String type)
	{
		this.type = type;
	}

	public BigDecimal getAmount()
	{
		return amount;
	}

	public void setAmount(BigDecimal amount)
	{
		this.amount = amount;
	}

	public Date getIssueDate()
	{
		return issueDate;
	}

	public void setIssueDate(Date issueDate)
	{
		this.issueDate = issueDate;
	}

	public Date getPaymentDate()
	{
		return paymentDate;
	}

	public void setPaymentDate(Date paymentDate)
	{
		this.paymentDate = paymentDate;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public User getUser()
	{
		return user;
	}

	public void setUser(User user)
	{
		this.user = user;
	}
	
}
