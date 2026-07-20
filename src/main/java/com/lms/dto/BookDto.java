package com.lms.dto;

public class BookDto {

    private Long id;

    private String bookName;

    private String authorName;

    private String category;

    private Double price;

    private String publisher;

    private Integer publishedYear;

    private Integer quantity;

    private Integer availableQuantity;

    public BookDto(Long id, String bookName, String authorName, String category,
                   Double price, String publisher, Integer publishedYear,
                   Integer quantity, Integer availableQuantity) {
        this.id = id;
        this.bookName = bookName;
        this.authorName = authorName;
        this.category = category;
        this.price = price;
        this.publisher = publisher;
        this.publishedYear = publishedYear;
        this.quantity = quantity;
        this.availableQuantity = availableQuantity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getBookName() {
        return bookName;
    }

    public void setBookName(String bookName) {
        this.bookName = bookName;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public Integer getPublishedYear() {
        return publishedYear;
    }

    public void setPublishedYear(Integer publishedYear) {
        this.publishedYear = publishedYear;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Integer getAvailableQuantity() {
        return availableQuantity;
    }

    public void setAvailableQuantity(Integer availableQuantity) {
        this.availableQuantity = availableQuantity;
    }
}