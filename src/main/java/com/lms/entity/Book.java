package com.lms.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "books")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String bookName;
    private String authorName;
    private String category;
    private Double price;
    private String accessType; // FREE, PAID
    private String publisher;
    private Integer publishedYear;
    private Integer quantity;
    private Integer availableQuantity;

    @Column(length = 5000)
    private String description;

    private String language;
    private Double rating;
    private Integer totalPages;

    @Column(length = 2000)
    private String readLink;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_image_id")
    private FileUploads bookImage;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_pdf_id")
    private FileUploads bookPdf;

    public Book() {
    }

    public Book(Long id, String bookName, String authorName, String category, Double price, String accessType,
                String publisher, Integer publishedYear, Integer quantity, Integer availableQuantity,
                String description, String language, Double rating, Integer totalPages,
                String readLink, FileUploads bookImage, FileUploads bookPdf) {
        this.id = id;
        this.bookName = bookName;
        this.authorName = authorName;
        this.category = category;
        this.price = price;
        this.accessType = accessType;
        this.publisher = publisher;
        this.publishedYear = publishedYear;
        this.quantity = quantity;
        this.availableQuantity = availableQuantity;
        this.description = description;
        this.language = language;
        this.rating = rating;
        this.totalPages = totalPages;
        this.readLink = readLink;
        this.bookImage = bookImage;
        this.bookPdf = bookPdf;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getBookName() { return bookName; }
    public void setBookName(String bookName) { this.bookName = bookName; }

    // Aligned alias method to support business service logic cleanly
    public String getTitle() { return this.bookName; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public String getAccessType() { return accessType; }
    public void setAccessType(String accessType) { this.accessType = accessType; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public Integer getPublishedYear() { return publishedYear; }
    public void setPublishedYear(Integer publishedYear) { this.publishedYear = publishedYear; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Integer getAvailableQuantity() { return availableQuantity; }
    public void setAvailableQuantity(Integer availableQuantity) { this.availableQuantity = availableQuantity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }

    public Double getRating() { return rating; }
    public void setRating(Double rating) { this.rating = rating; }

    public Integer getTotalPages() { return totalPages; }
    public void setTotalPages(Integer totalPages) { this.totalPages = totalPages; }

    public String getReadLink() { return readLink; }
    public void setReadLink(String readLink) { this.readLink = readLink; }

    public FileUploads getBookImage() { return bookImage; }
    public void setBookImage(FileUploads bookImage) { this.bookImage = bookImage; }

    public FileUploads getBookPdf() { return bookPdf; }
    public void setBookPdf(FileUploads bookPdf) { this.bookPdf = bookPdf; }
}