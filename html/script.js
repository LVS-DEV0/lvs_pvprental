const rentalContainer = document.getElementById('rental-container');
const rentalGrid = document.getElementById('rental-grid');
const rentalClose = document.getElementById('rental-close');

const openRentalUI = (data) => {
    const vehicles = data.vehicles;
    const locales = data.locales;
    if (!vehicles) return;

    if (rentalClose && locales.close) rentalClose.textContent = locales.close;

    const existingCards = rentalGrid.querySelectorAll('.vehicle-card');

    if (existingCards.length === vehicles.length) {
        vehicles.forEach((veh, index) => {
            const card = existingCards[index];
            const priceEl = card.querySelector('.vehicle-price');
            if (priceEl) {
                priceEl.textContent = veh.price == 0 ? locales.free : veh.price + (veh.vip ? ' LCOIN' : '$');
            }
        });
    } else {
        rentalGrid.innerHTML = '';
        vehicles.forEach((veh, index) => {
            const card = document.createElement('div');
            card.className = `vehicle-card ${veh.vip ? 'is-vip' : ''}`;

            let buttonClass = veh.vip ? 'btn-yellow' : 'btn-red';
            let buttonText = locales.rent_vehicle;

            card.innerHTML = `
                ${veh.vip ? '<div class="vip-badge-overlay">VIP</div>' : ''}
                <div class="vehicle-info">
                    <span class="vehicle-name">${veh.name}</span>
                    <span class="vehicle-price">${veh.price == 0 ? locales.free : veh.price + (veh.vip ? ' LCOIN' : '$')}</span>
                </div>
                <div class="vehicle-img-container">
                    <img src="https://docs.fivem.net/vehicles/${veh.model}.webp" class="vehicle-img" 
                         onerror="if (!this.getAttribute('data-tried-local')) { 
                             this.setAttribute('data-tried-local', 'true'); 
                             this.src='${veh.image}'; 
                         } else { 
                             this.src='italigto.png'; 
                         }">
                </div>
                <button class="vehicle-btn ${buttonClass}" data-index="${index}">${buttonText}</button>
            `;

            card.querySelector('button').addEventListener('click', () => {
                fetch(`https://${GetParentResourceName()}/selectVehicle`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ index: index + 1 })
                });
                closeRentalUI();
            });

            rentalGrid.appendChild(card);
        });
    }

    rentalContainer.style.display = 'flex';
};

const closeRentalUI = () => {
    rentalContainer.style.display = 'none';
    fetch(`https://${GetParentResourceName()}/closeRental`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
};

if (rentalClose) rentalClose.addEventListener('click', closeRentalUI);

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'openRental') {
        openRentalUI(data);
    } else if (data.action === 'closeAll') {
        closeRentalUI();
    }
});

window.addEventListener('keyup', (e) => {
    if (e.key === "Escape") {
        if (rentalContainer.style.display === 'flex') {
            closeRentalUI();
        }
    }
});
