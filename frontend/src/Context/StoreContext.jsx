import { createContext, useCallback, useEffect, useState } from "react";
import { menu_list } from "../assets/assets";
import axios from "axios";
import PropTypes from "prop-types";

export const StoreContext = createContext(null);

const StoreContextProvider = ({ children }) => {
    const url = import.meta.env.VITE_API_URL;

    const [food_list, setFoodList] = useState([]);
    const [cartItems, setCartItems] = useState({});
    const [token, setToken] = useState("");

    const currency = "₹";
    const deliveryCharge = 50;

    const addToCart = async (itemId) => {
        if (!cartItems[itemId]) {
            setCartItems((prev) => ({ ...prev, [itemId]: 1 }));
        } else {
            setCartItems((prev) => ({ ...prev, [itemId]: prev[itemId] + 1 }));
        }

        if (token) {
            await axios.post(url + "/api/cart/add", { itemId }, { headers: { token } });
        }
    };

    const removeFromCart = async (itemId) => {
        setCartItems((prev) => ({ ...prev, [itemId]: prev[itemId] - 1 }));

        if (token) {
            await axios.post(url + "/api/cart/remove", { itemId }, { headers: { token } });
        }
    };

    const getTotalCartAmount = () => {
        let totalAmount = 0;

        for (const item in cartItems) {
            if (cartItems[item] > 0) {
                const itemInfo = food_list.find((product) => product._id === item);

                if (itemInfo) {
                    totalAmount += itemInfo.price * cartItems[item];
                }
            }
        }

        return totalAmount;
    };

    const fetchFoodList = useCallback(async () => {
        const response = await axios.get(url + "/api/food/list");
        setFoodList(response.data.data);
    }, [url]);

    const loadCartData = useCallback(async (authToken) => {
        const response = await axios.post(
            url + "/api/cart/get",
            {},
            { headers: typeof authToken === "string" ? { token: authToken } : authToken }
        );

        setCartItems(response.data.cartData);
    }, [url]);

    useEffect(() => {
        async function loadData() {
            try {
                await fetchFoodList();

                const savedToken = localStorage.getItem("token");

                if (savedToken) {
                    setToken(savedToken);
                    await loadCartData(savedToken);
                }
            } catch (error) {
                console.error("Failed to load store data:", error);
            }
        }

        loadData();
    }, [fetchFoodList, loadCartData]);

    const contextValue = {
        url,
        food_list,
        menu_list,
        cartItems,
        addToCart,
        removeFromCart,
        getTotalCartAmount,
        token,
        setToken,
        loadCartData,
        setCartItems,
        currency,
        deliveryCharge
    };

    return (
        <StoreContext.Provider value={contextValue}>
            {children}
        </StoreContext.Provider>
    );
};

StoreContextProvider.propTypes = {
    children: PropTypes.node.isRequired,
};

export default StoreContextProvider;