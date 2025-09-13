import React from 'react';
import PropTypes from 'prop-types';

const Cell = ({ data }) => (
  <div className="cell-container">
    <article className="mini-post">
      <header>
        <h3>{data.title}</h3>
      </header>
      <ul className="project-list">
        {data.bulletPoints.map((point) => (
          <li key={point}>{point}</li>
        ))}
      </ul>
    </article>
  </div>
);

Cell.propTypes = {
  data: PropTypes.shape({
    title: PropTypes.string.isRequired,
    bulletPoints: PropTypes.arrayOf(PropTypes.string).isRequired,
  }).isRequired,
};

export default Cell;
