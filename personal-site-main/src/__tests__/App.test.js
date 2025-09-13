/**
 * @jest-environment jsdom
 */

import '@testing-library/jest-dom';
import '@testing-library/react';
import React, { act } from 'react';
import ReactDOM from 'react-dom/client';
import App from '../App';

describe('renders the app', () => {
  // mocks the fetch API used on the about page.
  const jsonMock = jest.fn(() => Promise.resolve({}));
  const textMock = jest.fn(() => Promise.resolve('Mock markdown content'));
  global.fetch = jest.fn(() => Promise.resolve({
    json: jsonMock,
    text: textMock,
  }));
  // mocks the scrollTo API used when navigating to a new page.
  window.scrollTo = jest.fn();

  let container;

  beforeEach(async () => {
    container = document.createElement('div');
    document.body.appendChild(container);
    await act(async () => {
      await ReactDOM.createRoot(container).render(<App />);
    });
  });

  afterEach(() => {
    document.body.removeChild(container);
    container = null;
    jest.clearAllMocks();
  });

  it('should render the app', async () => {
    expect(document.body).toBeInTheDocument();
  });

  it('should render the title', async () => {
    expect(document.title).toBe('Philip John');
  });

  it('should have navigation links', () => {
    const aboutLink = document.querySelector(
      '#header > nav > ul > li:nth-child(1) > a',
    );
    const resumeLink = document.querySelector(
      '#header > nav > ul > li:nth-child(2) > a',
    );
    const projectsLink = document.querySelector(
      '#header > nav > ul > li:nth-child(3) > a',
    );
    const contactLink = document.querySelector(
      '#header > nav > ul > li:nth-child(4) > a',
    );

    expect(aboutLink).toBeInTheDocument();
    expect(resumeLink).toBeInTheDocument();
    expect(projectsLink).toBeInTheDocument();
    expect(contactLink).toBeInTheDocument();
  });
});
