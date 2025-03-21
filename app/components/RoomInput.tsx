import React, { useState } from 'react';

const RoomInput = () => {
    const [title, setTitle] = useState('');
    const [description, setDescription] = useState('');
    const TITLE_LIMIT = 50; // Set your desired limit
    const DESCRIPTION_LIMIT = 200; // Set your desired limit

    const handleTitleChange = (e) => {
        if (e.target.value.length <= TITLE_LIMIT) {
            setTitle(e.target.value);
        }
    };

    const handleDescriptionChange = (e) => {
        if (e.target.value.length <= DESCRIPTION_LIMIT) {
            setDescription(e.target.value);
        }
    };

    return (
        <div>
            <input
                type="text"
                value={title}
                onChange={handleTitleChange}
                placeholder="Room Title"
            />
            <span>{`${title.length}/${TITLE_LIMIT}`}</span>
            <textarea
                value={description}
                onChange={handleDescriptionChange}
                placeholder="Room Description"
            />
            <span>{`${description.length}/${DESCRIPTION_LIMIT}`}</span>
        </div>
    );
};

export default RoomInput; 