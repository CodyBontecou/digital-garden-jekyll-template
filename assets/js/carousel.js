// assets/js/carousel.js
document.addEventListener('DOMContentLoaded', function () {
    const carousels = document.querySelectorAll('.image-carousel')

    carousels.forEach(carousel => {
        const items = carousel.querySelectorAll('.carousel-item')
        let currentIndex = 0

        const prevButton = carousel.querySelector('.carousel-prev')
        const nextButton = carousel.querySelector('.carousel-next')

        function showSlide(index) {
            items.forEach(item => item.classList.remove('active'))
            currentIndex = (index + items.length) % items.length
            items[currentIndex].classList.add('active')
        }

        prevButton.addEventListener('click', () => {
            showSlide(currentIndex - 1)
        })

        nextButton.addEventListener('click', () => {
            showSlide(currentIndex + 1)
        })

        // Optional: Add keyboard navigation
        document.addEventListener('keydown', e => {
            if (e.key === 'ArrowLeft') {
                showSlide(currentIndex - 1)
            } else if (e.key === 'ArrowRight') {
                showSlide(currentIndex + 1)
            }
        })
    })
})
